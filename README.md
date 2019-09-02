# Platform.sh Config Reader (Elixir)

This library provides a streamlined and easy to use way to interact with a Platform.sh environment. It offers utility methods to access routes and relationships more cleanly than reading the raw environment variables yourself.

## Usage
```
alias Platformsh.Config, as: Config

if Config.is_valid_platform? do
    IO.inspect Config.credentials("mysql")
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

> Take note that the library should be used in `config/releases.exs` rather that in `config/prod.exs` as yo want it to evaluate during runtime rather than during build time.


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `platformshconfig` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:platformshconfig, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/platformshconfig](https://hexdocs.pm/platformshconfig).

