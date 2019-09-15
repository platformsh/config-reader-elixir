# Platform.sh Config Reader (Elixir)

This library provides a streamlined and easy to use way to interact with a Platform.sh environment. It offers utility methods to access routes and relationships more cleanly than reading the raw environment variables yourself.

This small library tries to handle quite a bit of different use-cases from reading the configuration at run time to using releases. It tries both to be as magical as it can while staying out of your way.

For the simpler use-cases you don't __really__ need this, the configuration in Platform.sh is stable and you could simply put in your `config/prod.exs` something to the tune of :

```
config :template_elixir, TemplateElixir.Repo,
  username: "user",
  password: "",
  database: "main",
  hostname: "database.internal",
```

Still a better practice is probably to load this dynamically from the environment. To do so simply in your `mix.exs` add the dependency to this lib:

```
  defp deps do
    [
        {:platformshconfig, "~> 0.1.2"},
    ]
  end
```

And change the project def to something such as :

```
  def project do
    [
      ...
	  compilers: [:platformsh_conf] ++ Mix.compilers(),
	  default_task: "platformsh.config",	  
	  platformsh_config: [:ecto, :environment], 
      ...
    ]
  end
```

Here we add the lib to the compilers ... and  we configure what elements we want to load, we also add a default task so when you run `iex -S mix` and such the configuration will be available.

This will load the configuration to your application which will be automatically available through `Application.get_all_env(:my_elixir_app)` (here considering you called your). Ecto should find itself auto-configured as long as you have a MySQL or a PostgreSQL in your services.

In the `start` property of `.platform.app.yaml` you could now very simply put `mix run --no-halt`.

The lib provides mix tasks such as `mix platformsh.config` and `mix platformsh.run` 

Note that the assumption is that you will be running `MIX_ENV = prod` on all environments


## Usage Examples

Assuming we have a relationship name "database" defined in .platform.app.yaml  that points to a mysql database defined in .platform/services.yaml you can access its credentials as follows:

```
alias Platformsh.Config, as: Config

if Config.is_valid_platform?() do
    IO.inspect Config.credentials("database")
end
```

Will give out:
```
%{
  "cluster" => "ehsumw32qasrm-master-7rqtwti",
  "host" => "mysql.internal",
  "hostname" => "ofin73prjy2zp7dwzxgf2lizfu.mysql.service._.eu-2.platformsh.site",
  "ip" => "169.254.9.46",
  "password" => "",
  "path" => "main",
  "port" => 3306,
  "query" => %{"is_master" => true},
  "rel" => "mysql",
  "scheme" => "mysql",
  "service" => "mysql",
  "username" => "user"
}
````


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `platformshconfig` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:platformshconfig, "~> 0.1.2"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/platformshconfig](https://hexdocs.pm/platformshconfig).

