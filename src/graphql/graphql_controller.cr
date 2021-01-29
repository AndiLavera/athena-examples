require "athena"
require "graphql"
require "./query"
require "./incoming_query"

@[ADI::Register]
struct GraphqlQueryBody < ART::ParamConverterInterface
  # Define a customer configuration for this converter.
  # This allows us to provide a `entity` field within the annotation
  # in order to define _what_ entity should be queried for.
  configuration entity : IncomingQuery.class

  # Inject the serializer and validator into our converter.
  def initialize(
    @serializer : ASR::SerializerInterface,
    @validator : AVD::Validator::ValidatorInterface
  ); end

  # :inherit:
  def apply(request : HTTP::Request, configuration : Configuration) : Nil
    # Be sure to handle any possible exceptions here to return more helpful errors to the client.
    raise ART::Exceptions::BadRequest.new "Request body is empty." unless body = request.body

    # Deserialize the object, based on the type provided in the annotation.
    object = @serializer.deserialize configuration.entity, body, :json

    # Validate the object if it is validatable.
    if object.is_a? AVD::Validatable
      errors = @validator.validate object
      raise AVD::Exceptions::ValidationFailed.new errors unless errors.empty?
    end

    # Add the resolved object to the request's attributes.
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
    # SCHEMA.execute(query, variables, operation_name)
    pp incoming_query
    incoming_query.execute(SCHEMA)
  end
end
