defmodule Jokenauth.Db do
  use Tesla 
  plug Tesla.Middleware.Headers, [{"surreal-ns", "dbs"}, {"surreal-db", "db1"}, {"accept","application/json"}]
  plug Tesla.Middleware.BaseUrl, "http://localhost:8000"
  plug Tesla.Middleware.BasicAuth, username: "root", password: "root"

  def create_table(table) do
    post "/sql",
      "REMOVE TABLE #{table};
      CREATE TABLE #{table} SCHEMAFULL;
      DEFINE FIELD name ON TABLE #{table} TYPE string;
      DEFINE FIELD age ON TABLE #{table} TYPE string;"
  end

  def create_user(table, id, name, age) do
    post "/sql",
      "CREATE #{table}:#{id} CONTENT{
      name: #{name},
      age: #{age},
      }"
  end
end 
