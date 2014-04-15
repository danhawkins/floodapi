class API < Grape::API
  version 'v1', using: :header, vendor: 'floodata'

  mount Flood::Stations
  mount Flood::Data

  add_swagger_documentation
end