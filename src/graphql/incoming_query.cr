require "athena"
require "json"

class IncomingQuery
  include ASR::Serializable

  @[ASRA::Expose]
  property query : String

  @[ASRA::Expose]
  property variables : Hash(String, JSON::Any)?

  @[ASRA::Expose]
  property operation_name : String?

  def execute(schema : GraphQL::Schema)
    schema.execute(@query, @variables, @operation_name)
  end
end
