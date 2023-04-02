# Implementation of a TODO application
class PluginRoutes < Application
  base "/todo"

  TODOS = [] of String

  # returns the list of todos
  @[AC::Route::GET("/")]
  def index : Array(String)
    TODOS
  end
end
