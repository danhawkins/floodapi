class Station
  include Mongoid::Document

  field :stationReference, type: String
  field :coordActual, type: Array
  field :WiskiRiverName, type: String

  has_many :data, class_name: 'FloodData', primary_key: 'stationReference', foreign_key: 'stationReference'

  index( { coordActual: '2d' } )

  def entity
    Entity.new(self)
  end
  delegate :as_json, to: :entity

  class Entity < ::Flooding::Entity
    expose :stationReference
    expose :coordActual
    expose :WiskiRiverName
  end
end