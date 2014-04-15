module Flood
  class Stations < Grape::API


    namespace :stations do

      desc 'Return a list of stations'
      get do
        present Station.all
      end

    end


  end
end