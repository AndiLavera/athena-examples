require "athena"
require "graphql"
require "./query"
require "./incoming_query"

@[ADI::Register]
struct GraphqlQueryBody < ART::ParamConverterInterface
  configuration entity : IncomingQuery.class

  def initialize(
    @serializer : ASR::SerializerInterface,
    @validator : AVD::Validator::ValidatorInterface
  ); end

  def apply(request : HTTP::Request, configuration : Configuration) : Nil
    raise ART::Exceptions::BadRequest.new "Request body is empty." unless body = request.body

    object = @serializer.deserialize configuration.entity, body, :json

    if object.is_a? AVD::Validatable
      errors = @validator.validate object
      raise AVD::Exceptions::ValidationFailed.new errors unless errors.empty?
    end

    request.attributes.set configuration.name, object, configuration.entity
  end
end

class GraphQLController < ART::Controller
  SCHEMA = GraphQL::Schema.new(Query.new)

  # Post this to test:
  # {
  # 	"query": "{ user(id: \"1\") { name } echoStr(str: \"Hello GraphQL!\") }"
  # }
  #
  # It reads as:
  # {
  #   "query": "{
  #     user(id: \"1\") {
  #       name
  #     }
  #     echoStr(str: \"Hello GraphQL!\")
  #   }"
  # }
  @[ARTA::Post("/graphql")]
  @[ARTA::ParamConverter("incoming_query", converter: GraphqlQueryBody, entity: IncomingQuery)]
  def index(incoming_query : IncomingQuery) : String
    incoming_query.execute(SCHEMA)
  end
end
