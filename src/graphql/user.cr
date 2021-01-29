require "graphql"

# This would be a model for Granite or something
@[GraphQL::Object]
class User
  include GraphQL::ObjectType

  def initialize(@name : String)
    # This is not a `GraphQL::Field` so it will not show up in queries
    @first_name = "Hello world"
  end

  @[GraphQL::Field]
  def name : String
    @name
  end
end
