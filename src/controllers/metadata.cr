# description of the welcome klass
class Metadata < Application
  base "/.well-known"

  HUMAN_NAME = App::NAME.gsub(/\-|\_/, ' ')
  MODEL_NAME = App::NAME.gsub(/\-/, '_')

  # The manifest file that defines the plugin
  # it's using the macro DSL so it is not included
  # in the OpenAPI docs that are provided to ChatGPT
  # https://platform.openai.com/docs/plugins/getting-started/plugin-manifest
  get "/ai-plugin.json", :ai_plugin_json do
    host = "#{request_protocol}://#{request.headers["Host"]?}"
    description = App::DESCRIPTION || raise "please provide a description in your shard.yml"

    render(json: {
      "schema_version":        "v1",
      "name_for_human":        HUMAN_NAME,
      "name_for_model":        MODEL_NAME,
      "description_for_human": description,
      "description_for_model": description,
      "auth":                  {
        "type": "none",
      },
      "api": {
        "type":                  "openapi",
        "url":                   "#{host}/.well-known/openapi.yaml",
        "is_user_authenticated": false,
      },
      "logo_url":       "#{host}/logo.png",
      "contact_email":  "support@place.technology",
      "legal_info_url": "https://www.placeos.com/terms-of-use",
    })
  end

  # this file is built as part of the docker build
  OPENAPI = File.exists?("openapi.yml") ? YAML.parse(File.read "openapi.yml") : ActionController::OpenAPI.generate_open_api_docs(
    title: HUMAN_NAME,
    version: App::VERSION,
    description: App::DESCRIPTION || "OpenAPI docs for ChatGPT plugin"
  )

  # returns the OpenAPI representation of this service in JSON format
  # https://platform.openai.com/docs/plugins/getting-started/openapi-definition
  get "/openapi.json", :openapi_json do
    render json: OPENAPI.to_json
  end

  # returns the OpenAPI representation of this service in YAML format
  # https://platform.openai.com/docs/plugins/getting-started/openapi-definition
  get "/openapi.yaml", :openapi_yaml do
    render yaml: OPENAPI.to_yaml
  end
end
