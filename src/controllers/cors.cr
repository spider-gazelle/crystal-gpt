# Implementation of a TODO application
class CORS < Application
  base "/"

  # implements CORS
  options "/*", :cors_options do
    # Access-Control-Allow-Origin is set in the before_filter
    response.headers["Access-Control-Allow-Methods"] = "GET, POST, PUT, PATCH, DELETE, OPTIONS, HEAD"
    # NOTE:: when using Auth this should probably specify the headers
    # as Authorization header and cookies are not sent when using a wildcard
    # one possible solution is: response.headers["Access-Control-Allow-Headers"] = request.headers["Access-Control-Request-Headers"]? || "*"
    response.headers["Access-Control-Allow-Headers"] = "*"
    response.headers["Access-Control-Max-Age"] = "86400"
    head :no_content
  end
end
