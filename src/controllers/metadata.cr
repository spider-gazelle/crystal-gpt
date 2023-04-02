# description of the welcome klass
class Metadata < Application
  base "/.well-known"

  # The manifest file that defines the plugin
  # it's using the macro DSL so it is not included
  # in the OpenAPI docs that are provided to ChatGPT
  get "/ai-plugin.json", :ai_plugin_json do
    host = "#{request_protocol}://#{request.headers["Host"]?}"

    render(json: {
      "schema_version":        "v1",
      "name_for_human":        "TODO Plugin",
      "name_for_model":        "todo",
      "description_for_human": "Plugin for managing a TODO list, you can add, remove and view your TODOs.",
      "description_for_model": "Plugin for managing a TODO list, you can add, remove and view your TODOs.",
      "auth":                  {
        "type": "none",
      },
      "api": {
        "type":                  "openapi",
        "url":                   "#{host}/openapi.yaml",
        "is_user_authenticated": false,
      },
      "logo_url":       "#{host}/logo.png",
      "contact_email":  "support@place.technology",
      "legal_info_url": "https://www.placeos.com/terms-of-use",
    })
  end

  # this file is built as part of the docker build
  OPENAPI = File.exists?("openapi.yml") ? File.read("openapi.yml") : ActionController::OpenAPI.generate_open_api_docs(
    title: App::NAME,
    version: App::VERSION,
    description: App::DESCRIPTION || "OpenAPI docs for ChatGPT plugin"
  ).to_yaml

  # returns the OpenAPI representation of this service
  get "/openapi.yaml", :openapi_yaml do
    render yaml: OPENAPI
  end
end
