require_relative '../../lib/download_latest_file'

class ReaderWorker
  include Sidekiq::Worker

  def perform(*args)
    download_latest_file
  end
end

