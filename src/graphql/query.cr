require "graphql"
require "./user"

# This is the class graphql uses to query through. Any models
# that should be queryable would be aggregated here.
@[GraphQL::Object]
class Query
  include GraphQL::ObjectType
  include GraphQL::QueryType

  # This would be a db
  @users = {
    "1" => User.new("andrew"),
  }

  # Docs on fields:
  # https://graphql.org/learn/queries/#fields
  #
  # snake_case fields are camelCased when querying.
  # Reference this with `{ echoStr }`
  @[GraphQL::Field]
  def echo_str(str : String) : String
    str
  end

  # Realistically, this would be querying the db
  @[GraphQL::Field]
  def user(id : String) : User
    @users[id]
  end
end
