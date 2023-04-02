require "./spec_helper"

describe Metadata do
  client = AC::SpecHelper.client

  it "creates todos" do
    result = client.post("/todo", body: %({"description": "first todo"}))
    result.status_code.should eq 201
    JSON.parse(result.body).should eq({
      "description" => "first todo",
      "completed"   => false,
    })

    result = client.post("/todo", body: %({"description": "second todo"}))
    result.status_code.should eq 201
    JSON.parse(result.body).should eq({
      "description" => "second todo",
      "completed"   => false,
    })
  end

  it "lists todos" do
    result = client.get("/todo")
    result.status_code.should eq 200

    JSON.parse(result.body).should eq([{
      "description" => "first todo",
      "completed"   => false,
    }, {
      "description" => "second todo",
      "completed"   => false,
    }])
  end

  it "marks a todo as completed" do
    result = client.delete("/todo/0")
    result.status_code.should eq 202

    result = client.get("/todo")
    result.status_code.should eq 200
    JSON.parse(result.body).should eq([{
      "description" => "first todo",
      "completed"   => true,
    }, {
      "description" => "second todo",
      "completed"   => false,
    }])
  end
end
