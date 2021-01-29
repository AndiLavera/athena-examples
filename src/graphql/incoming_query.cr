require "json"

class IncomingQuery
  include ASR::Serializable

  @[ASRA::Expose]
  property query : String

  @[ASRA::Expose]
  property variables : Hash(String, JSON::Any)?

  @[ASRA::Expose]
  property operation_name : String?

  def initialize(json : JSON::Any)
    @query = json["query"]
    @variables = json["variables"]?
    @operation_name = json["operation"]?
  end

  def execute(schema : GraphQL::Schema)
    schema.execute(@query, @variables, @operation_name)
  end
end
