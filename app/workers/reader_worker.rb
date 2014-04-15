require_relative '../../lib/process_lastest_file'

class ReaderWorker
  include Sidekiq::Worker

  def perform(*args)
    process_lastest_file
  end
end

