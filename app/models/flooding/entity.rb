class Flooding::Entity < ::Grape::Entity
  expose :id do |object, options|
    object.new_record? ? nil : object.id.to_s
  end
end