# File to download every 15 minutes
# http://flooddata.alphagov.co.uk/stations.tsv

# There is a case when the file is rotated at mid-night which we need to cover for

require 'net/http'

$data_file = File.expand_path("../../data/stations.tsv", __FILE__)
$old_data_file = "#{$data_file}_old"
$server_data_file = File.expand_path("../../data/all_stations.tsv", __FILE__)
$conversion_file = File.expand_path("../../db/convertFlood.js", __FILE__)

$database = 'flooddata_staging'

def process_lastest_file
  rotate_last_file
  download_latest_file
  identify_new_records
  insert_data_into_db
end

def download_file(filename)
  puts "Donwloading file: #{filename} ..."
  Net::HTTP.start("flooddata.alphagov.co.uk") do |http|
      resp = http.get("/stations.tsv")
      open(filename, "wb") do |file|
          file.write(resp.body)
      end
  end
  puts "Downloaded with no errors at #{filename}"
end

def download_latest_file
  download_file($server_data_file)
end

def rotate_last_file
  puts "Deleting file: #{$old_data_file}"
  File.delete($old_data_file) if File.exist?($old_data_file)

  puts "Renaming current file to old file"
  puts "mv #{$server_data_file} #{$old_data_file}"
  `mv #{$server_data_file} #{$old_data_file}`
end

def identify_new_records
  number_of_records_in_previous_file = `wc -l #{$old_data_file}`.split(" ")[0].to_i
  number_of_records_in_latest_file = `wc -l #{$server_data_file}`.split(" ")[0].to_i
  number_of_new_records = number_of_records_in_latest_file - number_of_records_in_previous_file
  puts "Old records: #{number_of_records_in_previous_file}"
  puts "New records: #{number_of_records_in_latest_file}"
  puts "Difference: #{number_of_new_records}"

  if number_of_new_records > 0
    process_same_file_with_new_records number_of_new_records
  elsif number_of_new_records < 0
    process_a_new_file_for_new_day
  elsif number_of_new_records ==0
    File.delete($data_file) if File.exist?($data_file)
  end

  number_of_records_in_extracted_file = number_of_extracted_records
  puts "Extracted records: #{number_of_records_in_extracted_file}"
end

def process_same_file_with_new_records (number_of_new_records)
  puts "Extracting the last #{number_of_new_records} from the latest file"
  `head -n 1 #{$server_data_file} > #{$data_file}`
  `tail -n #{number_of_new_records} #{$server_data_file} >> #{$data_file}`
end

def process_a_new_file_for_new_day
  puts "A new data file has been generated, importing all data in the file"
  puts "cp #{$server_data_file} #{$data_file}"
  `cp #{$server_data_file} #{$data_file}`
end

def number_of_extracted_records
  return 0 unless File.exist?($data_file)
  `wc -l #{$data_file}`.split(" ")[0].to_i
end

def insert_data_into_db
  puts "Importanting #{number_of_extracted_records} records..."
  if number_of_extracted_records == 0
    puts "No data to import. Db not updated."
    return
  end

  drop_db = "mongo #{ENV['MONGOURL']}/#{ENV['MONGOUSER']} -u#{ENV['MONGOUSER']} -p#{ENV['MONGOPASS']} --eval \"db.#{$database}.drop()\""
  puts drop_db
  `#{drop_db}`

  server_details = ENV['MONGOURL'].split(':')
  import_file = "mongoimport --host #{server_details[0]} --port #{server_details[1]} -u#{ENV['MONGOUSER']} -p#{ENV['MONGOPASS']} -d #{ENV['MONGOUSER']} -c #{$database} --file #{$data_file} --type tsv --headerline"
  puts import_file
  `#{import_file}`

  process_file = "mongo #{ENV['MONGOURL']}/#{ENV['MONGOUSER']} -u#{ENV['MONGOUSER']} -p#{ENV['MONGOPASS']} < #{$conversion_file}"
  puts process_file
  `#{process_file}`
end

def download_base_file

end

download_latest_file
