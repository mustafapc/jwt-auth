defmodule JokenauthWeb.PageController do
  use JokenauthWeb, :controller
  alias Jokenauth.Db 
  alias Jokenauth.Token
  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def info(conn, params) do
  Db.create_table("person")
  Db.create_user("person", "mustafa", params["name"], params["age"])
  IO.inspect(params)
  name = params["name"]
  _password = params["password"]
  token_config = case params["role"] do
  "user" -> Map.put(%{}, "scope", %Joken.Claim{
      generate: fn -> "user" end,
    validate: fn val, _claims, _context -> val in {"user", "admin"} end
    })
  "admin" -> Map.put(%{}, "scope", %Joken.Claim{
        generate: fn -> "admin" end,
validate: fn val, _claims, _context -> val in {"user", "admin"} end
      })
  end
  
  signer = Joken.Signer.create("HS256", "signed")
    {:ok, claims} = Joken.generate_claims(token_config, %{"name"=>name, "age"=>params["age"], "role"=>params["role"]})
    {:ok, jwt, _claims} = Joken.encode_and_sign(claims, signer)
  k = inspect Joken.verify(jwt, signer)
  IO.inspect(k)
  text(conn, "#{jwt}\n#{k}")
  end
end
