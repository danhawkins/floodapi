class FloodData
  include Mongoid::Document
  store_in collection: "flooddata"

  field :stationReference, type: String
  field :region, type: String
  field :ngr, type: String
  field :stationName, type: String
  field :parameter, type: String
  field :qualifier, type: String
  field :units, type: String
  field :value, type: Float
  field :Time, type: DateTime
  field :coordActual, type: Array
  field :WiskiRiverName, type: String

  index( { coordActual: '2d' } )

  def entity
    Entity.new(self)
  end
  delegate :as_json, to: :entity

  class Entity < ::Flooding::Entity
    expose :stationReference
    expose :region
    expose :ngr
    expose :stationName
    expose :parameter
    expose :qualifier
    expose :units
    expose :value
    expose :Time
    expose :coordActual
    expose :WiskiRiverName
  end

end