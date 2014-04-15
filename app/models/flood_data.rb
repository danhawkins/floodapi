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
  index "Time" => 1


  def self.aggregate(params)

    params[:group] ||= 'day'
    case params[:group]
    when 'day'
      dateGroup = { year: { '$year' => '$Time'} , month: { '$month' => '$Time'}, day: { '$dayOfMonth' => '$Time' } }
    when 'week'
      dateGroup = { year: { '$year' => '$Time'}, week: { '$week' => '$Time'} }
    when 'month'
      dateGroup = { year: { '$year' => '$Time'}, month: { '$month' => '$Time'} }
    when 'year'
      dateGroup = { year: { '$year' => '$Time'} }
    end

    options = []

    matchParams = {}
    matchParams['stationReference'] = params[:stationReference].numeric? ? params[:stationReference].to_f : params[:stationReference] if params[:stationReference]
    #matchParams['parameter'] = CGI.unescape(params[:type].to_s) unless params[:type].nil? || params[:type].blank?

    matchParams["Time"] = { "$gte" => params[:start]} if params[:start].present?
    matchParams["Time"] = { "$lte" => params[:end]} if params[:end].present?

    options << { '$match' => matchParams } unless matchParams.empty?  
    options << { '$group' => { _id: { stationReference: '$stationReference', parameter: '$parameter'}.merge(dateGroup), value: {'$avg' => '$value'} } }

    collection.aggregate(options)
  end

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