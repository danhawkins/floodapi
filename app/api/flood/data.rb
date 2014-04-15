module Flood
  class Data < Grape::API

    namespace :flood_data do

      desc 'Return a list of flood data'
      get do
        present FloodData.all
      end

    end

  end
end