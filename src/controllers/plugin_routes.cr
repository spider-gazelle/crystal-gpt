require "json"

# Implementation of a TODO application
class PluginRoutes < Application
  base "/todo"

  # an individual todo
  class Todo
    include JSON::Serializable

    getter description : String

    @[JSON::Field(ignore_deserialize: true)]
    property? completed : Bool = false
  end

  TODOS = [] of Todo

  # returns the list of todos
  @[AC::Route::GET("/")]
  def index : Array(Todo)
    TODOS
  end

  # append a new todo to the end of the list
  @[AC::Route::POST("/", body: :todo, status_code: HTTP::Status::CREATED)]
  def create(todo : Todo) : Todo
    TODOS << todo
    todo
  end

  # return the todo at the index provided, indexes start at 0
  @[AC::Route::GET("/:index")]
  def show(index : Int32) : Todo
    todo = TODOS[index]?
    raise AC::Error::NotFound.new("index #{index} is beyond the end of the array") unless todo
    todo
  end

  # modify the todo at the index provided
  #
  # indexes start at 0 and this will also set completed to false
  @[AC::Route::PUT("/:index", body: :todo)]
  def update(index : Int32, todo : Todo) : Todo
    raise AC::Error::NotFound.new("index #{index} is beyond the end of the array") if index >= TODOS.size
    TODOS[index] = todo
    todo
  end

  # mark the todo, at the index provided, as completed
  #
  # indexes start at 0
  @[AC::Route::DELETE("/:index", status_code: HTTP::Status::ACCEPTED)]
  def complete(index : Int32) : Nil
    raise AC::Error::NotFound.new("index #{index} is beyond the end of the array") if index >= TODOS.size
    todo = TODOS[index]
    todo.completed = true
  end
end
