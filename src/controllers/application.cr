require "uuid"

abstract class Application < ActionController::Base
  # Configure your log source name
  # NOTE:: this is chaining from App::Log
  Log = ::App::Log.for("controller")

  # Add CORS header to all requests so GPT chat can access the plugin
  @[AC::Route::Filter(:before_action)]
  def set_cors_headers
    response.headers["Access-Control-Allow-Origin"] = "https://chat.openai.com"
  end

  # This makes it simple to match client requests with server side logs.
  # When building microservices this ID should be propagated to upstream services.
  @[AC::Route::Filter(:before_action)]
  def set_request_id
    request_id = UUID.random.to_s
    Log.context.set(
      client_ip: client_ip,
      request_id: request_id
    )
    response.headers["X-Request-ID"] = request_id
  end

  # covers no acceptable response format and not an acceptable post format
  @[AC::Route::Exception(AC::Route::NotAcceptable, status_code: HTTP::Status::NOT_ACCEPTABLE)]
  @[AC::Route::Exception(AC::Route::UnsupportedMediaType, status_code: HTTP::Status::UNSUPPORTED_MEDIA_TYPE)]
  def bad_media_type(error) : AC::Error::ContentResponse
    AC::Error::ContentResponse.new error: error.message.as(String), accepts: error.accepts
  end

  # handles paramater missing or a bad paramater value / format
  @[AC::Route::Exception(AC::Route::Param::MissingError, status_code: HTTP::Status::UNPROCESSABLE_ENTITY)]
  @[AC::Route::Exception(AC::Route::Param::ValueError, status_code: HTTP::Status::BAD_REQUEST)]
  def invalid_param(error) : AC::Error::ParameterResponse
    AC::Error::ParameterResponse.new error: error.message.as(String), parameter: error.parameter, restriction: error.restriction
  end

  # 404 if resource not present
  @[AC::Route::Exception(AC::Error::NotFound, status_code: HTTP::Status::NOT_FOUND)]
  def resource_not_found(error) : AC::Error::CommonResponse
    Log.debug(exception: error) { error.message }
    AC::Error::CommonResponse.new(error)
  end
end
