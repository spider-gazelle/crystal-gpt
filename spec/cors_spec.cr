require "./spec_helper"

describe Metadata do
  client = AC::SpecHelper.client

  it "respond to options requests" do
    result = client.options("/todo")
    result.headers["Access-Control-Allow-Origin"]?.should eq "https://chat.openai.com"
    result.headers["Access-Control-Allow-Methods"]?.should eq "GET, POST, PUT, PATCH, DELETE, OPTIONS, HEAD"
    result.headers["Access-Control-Allow-Headers"]?.should eq "*"
    result.headers["Access-Control-Max-Age"]?.should eq "86400"
    result.status_code.should eq 204
  end
end
