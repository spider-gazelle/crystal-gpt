require "./spec_helper"

describe Metadata do
  client = AC::SpecHelper.client

  it "should render the ai-plugin.json file" do
    shard_yml = YAML.parse File.read("./shard.yml")
    human_name = shard_yml["name"].as_s.gsub(/\-|\_/, ' ')
    model_name = shard_yml["name"].as_s.gsub(/\-/, '_')
    description = shard_yml["description"].as_s

    result = client.get("/.well-known/ai-plugin.json")
    result.headers["Access-Control-Allow-Origin"]?.should eq "*"

    plugin_metadata = JSON.parse result.body
    plugin_metadata["name_for_human"].should eq human_name
    plugin_metadata["name_for_model"].should eq model_name
    plugin_metadata["description_for_human"].should eq description
    plugin_metadata["description_for_model"].should eq description
  end

  it "should render the OpenAPI specs of the routes" do
    result = client.get("/.well-known/openapi.yaml")
    result.headers["Access-Control-Allow-Origin"]?.should eq "*"

    openapi = YAML.parse result.body
    openapi["paths"].as_h.has_key?("/todo").should eq true
    openapi["paths"].as_h.has_key?("/.well-known/openapi.yaml").should eq false
  end
end
