# File to download every 15 minutes
# http://flooddata.alphagov.co.uk/stations.tsv

require 'net/http'

$data_file = File.expand_path("../../data/stations.tsv", __FILE__)

def download_latest_file
  puts "Donwloading file: http://flooddata.alphagov.co.uk/stations.tsv ..."
  Net::HTTP.start("flooddata.alphagov.co.uk") do |http|
      resp = http.get("/stations.tsv")
      open($data_file, "wb") do |file|
          file.write(resp.body)
      end
  end
  puts "Downloaded with no errors at #{$data_file}"
end

download_latest_file
