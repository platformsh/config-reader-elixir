defmodule Platformsh.Config do
  @moduledoc """
  	Reads Platform.sh configuration from environment variables.
  	See: https://docs.platform.sh/development/variables.html
  	The following are 'magic' properties that may exist on a Config object. Before accessing a property, check its
  	existence with hasattr(config, variableName). Attempting to access a nonexistent variable will throw an exception.
  	Attributes:
  	    (The following properties are available at build time and run time.)
  	    project (string):
  	        The project ID.
  	    application_name (string):
  	        The name of the application, as defined in its configuration.
  	    tree_id (string):
  	        An ID identifying the application tree before it was built: a unique hash is generated based on the contents
  	        of the application's files in the repository.
  	    app_dir (string):
  	        The absolute path to the application.
  	    project_entropy (string):
  	        A random string generated for each project, useful for generating hash keys.
  	    (The following properties are only available at runtime.)
  	    branch (string):
  	        The Git branch name.
  	    environment (string):
  	        The environment ID (usually the Git branch plus a hash).
  	    document_root (string):
  	        The absolute path to the web root of the application.
  	    smtp_host (string):
  	        The hostname of the Platform.sh default SMTP server (an empty string if emails are disabled on the
  	        environment.
  	    port (string):
  	        The TCP port number the application should listen to for incoming requests.
  	    socket (string):
  	        The Unix socket the application should listen to for incoming requests.
  	. Platform.sh Environment Variables
  	        https://docs.platform.sh/development/variables.html
  """

  @doc """
    Decodes a Platform.sh environment variable.
          Args:
              variable (string):
                  Base64-encoded JSON (the content of an environment variable).
          Returns:
              An dict (if representing a JSON object), or a scalar type.
          Raises:
              JSON decoding error.
  """
  def decode(variable) do
    if variable != nil do
      Poison.decode!(Base.decode64!(variable))
    else
      nil
    end
  end

  @doc """
    value/1 Reads unprefixed environment variable, taking the prefix into account.
      Args:
         item (string):
             The variable to read.
  """
  def value(item) do
    directVariablesRuntime = %{
      port: "PORT",
      socket: "SOCKET"
    }

    System.get_env(directVariablesRuntime[item])
  end

  @doc """
    value/2 Reads an environment variable, taking the prefix into account.
      Args:
         item (string):
             The variable to read.
         prefix (string):
             The Environment variable prefix
  """
  def value(item, env_prefix) do
    # Local index of the variables that can be accessed as direct properties
    # (runtime only). The key is the property that will be read. The value is the environment variables, minus
    # prefix, that contains the value to look up.

    directVariables = %{
      project: "PROJECT",
      app_dir: "APP_DIR",
      application_name: 'APPLICATION_NAME',
      tree_id: "TREE_ID",
      project_entropy: "PROJECT_ENTROPY"
    }

    directVariablesRuntime = %{
      branch: "BRANCH",
      environment: "ENVIRONMENT",
      document_root: "DOCUMENT_ROOT",
      smtp_host: "SMTP_HOST"
    }

    inDirectVariablesRuntime = %{
      routes: "ROUTES",
      relationships: "RELATIONSHIPS",
      application: "APPLICATION",
      variables: "VARIABLES"
    }

    cond do
      Map.has_key?(directVariables, item) ->
        System.get_env("#{env_prefix}#{directVariables[item]}")

      Map.has_key?(directVariablesRuntime, item) ->
        System.get_env("#{env_prefix}#{directVariablesRuntime[item]}")

      Map.has_key?(inDirectVariablesRuntime, item) ->
        decode(System.get_env("#{env_prefix}#{inDirectVariablesRuntime[item]}"))

      True ->
        nil
    end
  end

  @doc """
  Local index of the variables that can be accessed as direct properties (build and
  runtime). The key is the property that will be read. The value is the environment variables, minus prefix,
  that contains the value to look up.
  """
  def environment() do
    env_prefix = 'PLATFORM_'

    %{
      # Local index of the variables that can be accessed at build-time
      project: value(:project, env_prefix),
      app_dir: value(:app_dir, env_prefix),
      application_name: value(:application_name, env_prefix),
      tree_id: value(:tree_id, env_prefix),
      project_entropy: value(:project_entropy, env_prefix),
      mode: value(:mode, env_prefix),

      # Local index of the variables that can be accessed as direct properties
      # (runtime only). 
      branch: value(:branch, env_prefix),
      environment: value(:environment, env_prefix),
      document_root: value(:document_root, env_prefix),
      smtp_host: value(:smtp_host, env_prefix),

      # Local index of variables available at runtime that have no prefix.
      port: value(:port),
      socket: value(:socket),

      # Local index of variables available at runtime that need decoding
      routes: value(:routes, env_prefix),
      relationships: value(:relationships, env_prefix),
      application: value(:application, env_prefix),
      variables: value(:variables, env_prefix)
    }
  end

  @doc """
  Checks whether the code is running on a platform with valid environment variables.
  Returns:
      bool:
          True if configuration can be used, False otherwise.
  """
  def is_valid_platform?() do
    environment()[:application_name] != nil
  end

  @doc """
  Checks whether the code is running in a build environment.
  Returns:
      bool: True if running in build environment, False otherwise.
  """
  def in_build?() do
    is_valid_platform?() and environment()[:environment] == nil
  end

  @doc """
  Checks whether the code is running in a runtime environment.
  Returns:
      bool: True if in a runtime environment, False otherwise.
  """
  def in_runtime?() do
    is_valid_platform?() and environment()[:environment]
  end

  @doc """
  Retrieves the credentials for accessing a relationship.
  Args:
      relationship (string):
          The relationship name as defined in .platform.app.yaml
       for the moment it returns the first in the index of clustered services
  Returns:
      The credentials dict for the service pointed to by the relationship.
  """
  def credentials(relationship) do
    [config | _tail] = environment()[:relationships][relationship]
    config
  end

  @doc """
  Retrieves the unfiltered credentials for accessing a relationship.
  Returns:
      The credentials dict for the service pointed to by the relationship.
  """
  def credentials() do
    environment()[:relationships]
  end

  @doc """
  variables/1 Returns a variable from the VARIABLES dict.
  Note:
      Variables prefixed with `env`: can be accessed as normal environment variables. This method will return
      such a variable by the name with the prefix still included. Generally it's better to access those variables
      directly.
  Args:
      name (string):
          The name of the variable to retrieve.
      default (mixed):
          The default value to return if the variable is not defined. Defaults to nil.
  Returns:
      The value of the variable, or  nil. This may be a string or a dict.
  """
  def variables(name) do
    if Map.has_key?(environment()[:variables], name) do
      environment()[:variables][name]
    else
      nil
    end
  end

  @doc """
  variables/0 Returns the full variables dict.
  If you're looking for a specific variable, the variable() method is a more robust option.
  This method is for classes where you want to scan the whole variables list looking for a pattern.
  It's valid for there to be no variables defined at all, so there's no guard for missing values.
  Returns:
      The full variables dict.
  """
  def variables() do
    environment()[:variables]
  end

  @doc """
  routes/0 Return the routes definition.
  Returns:
      The routes dict.
  Raises:
      RuntimeError:
          If the routes are not accessible due to being in the wrong environment.
  """
  def routes() do
    environment()[:routes]
  end

  @doc """
  routes/1  Get route definition by route ID.
  Args:
      route_id (string):
          The ID of the route to load.
  Returns:
      The route definition. The generated URL of the route is added as a 'url' key.
  Raises:
      KeyError:
          If there is no route by that ID, an exception is thrown.
  """
  def routes(route_id) do
    environment()[:routes][route_id]
  end

  @doc """
  Returns the application definition dict.
  This is, approximately, the .platform.app.yaml file as a nested dict. However, it also has other information
  added by Platform.sh as part of the build and deploy process.
  Returns:
      The application definition dict.
  """
  def application() do
    environment()[:application]
  end

  @doc """
  Determines if the current environment is a Platform.sh Dedicated Enterprise environment.
  Returns:
      bool:
          True on an Enterprise environment, False otherwise.
  """
  def on_dedicated_enterprise?() do
    is_valid_platform?() and environment()[:mode] == 'enterprise'
  end

  @doc """
  Determines if the current environment is a production environment.
  Note:
      There may be a few edge cases where this is not entirely correct on Enterprise, if the production branch is
      not named `production`. In that case you'll need to use your own logic.
  Returns:
      bool:
          True if the environment is a production environment, False otherwise. It will also return False if not
          running on Platform.sh or in the build phase.
  """
  def on_production?() do
    prod_branch = if on_dedicated_enterprise?(), do: "production", else: "master"
    environment()[:branch] == prod_branch
  end

  @doc """
  Determines if a routes are defined
  Returns:
      bool:
          True if the relationship is defined, False otherwise.
  """
  def has_routes?() do
    environment()[:routes] != nil
  end

  @doc """
  Determines if a relationships are defined, and thus has credentials available.
  Returns:
      bool:
          True if the relationship is defined, False otherwise.
  """
  def has_relationships() do
    environment()[:relationships] != nil
  end

  @doc """
  Determines if a relationship is defined, and thus has credentials available.
  Args:
      relationship (string):
          The name of the relationship to check.
  Returns:
      bool:
          True if the relationship is defined, False otherwise.
  """
  def has_relationship(relationship) do
    Map.has_key?(environment()[:relationships], relationship)
  end

  @doc """
  Returns the just the names of relationships
  Returns:
      a list with relationship names
  """
  def relationships() do
    Map.keys(environment()[:relationships])
  end

  @doc """
  Formats a dsn for use with ecto
  Returns:
      a string in the format of a dsn url for ecto
  """
  def ecto_dsn_formatter(config) do
    username = config["username"]
    password = config["password"]
    hostname = config["host"]
    path = config["path"]
    "ecto://#{username}:#{password}@#{hostname}/#{path}"
  end

  @doc """
  Guesses a relational database for ecto
  Returns:
      a string in the format of a dsn url for ecto or nil if none found, 
   this is guesss work so we don't want to crash on no value
  """
  def guess_relational_database() do
    if in_runtime?() do
      cred =
        Enum.find(Platformsh.Config.credentials(), fn {_rel, cred} ->
          [config | _tail] = cred
          String.contains?(config["scheme"], ["mysql", "pgsql"])
        end)

      [[config | _tailer] = _outer_list | _tail] = Tuple.to_list(Tuple.delete_at(cred, 0))
      config
    end
  end

  @doc """
  Gets primary route
  Returns:
       a url of the primary route
  """
  def primary_route() do
    if in_runtime?() do
      route =
        Enum.find(Platformsh.Config.routes(), fn {_route, conf} -> conf["primary"] == true end)

      if route != nil do
        List.first(Tuple.to_list(route))
      else
        # We got nothing pick the top route. 
        List.first(Map.keys(Platformsh.Config.routes()))
      end
    end
  end

  @doc """
  Magic configurations from process ENV may be configurable, so process them as a list of configurable items
  """
  def config(l) when is_list(l) do
    Enum.reduce(l, [], &Config.Reader.merge(&2, config(&1)))
  end

  @doc """
  Load all magical config elements
  """
  def config(:all) do
    config([:ecto, :environment])
  end

  @doc """
  Default ecto repository to configure is `Repo` module
  """
  def config(:ecto) do
    [repo | _tail] = Application.get_all_env(Mix.Project.config()[:app])[:ecto_repos]
    config({:ecto, repo})
  end

  @doc """
  Actual configuration of Ecto
  """
  def config({:ecto, repo}) do
    conf = Platformsh.Config.guess_relational_database()

    [
      "#{Mix.Project.config()[:app]}": [
        "#{repo}": [
          username: conf["username"],
          password: conf["password"],
          hostname: conf["host"],
          database: conf["path"]
        ]
      ]
    ]
  end

  @doc """
  Load everything we have into the environment
  """
  def config(:environment) do
    ["#{Mix.Project.config()[:app]}": [env: Platformsh.Config.environment()]]
  end
end

defmodule Platformsh.ConfigProvider do
  require Logger

  @moduledoc """
     	if app is started as a release, add this config provider
  """

  @doc """
  To derive PlatformSh config at bootup of a release, add this config provider to release
  """
  def init(magics) do
    magics
  end

  @doc """
  Loads PlatformSh config explictly
  """
  def load(config, magics) do
    if Platformsh.Config.is_valid_platform?() do
      Config.Reader.merge(config, Platformsh.Config.config(magics || :all))
    else
      Logger.warn("Trying to load Platform.sh Config but environment not detected")
    end
  end
end

defmodule Mix.Tasks.Platformsh.Config do
  require Logger

  @moduledoc """
  Add mix tasks
  If app is started with mix, add this task beforehand 	
  """

  @doc """
  to derive PlatformSh config if app is launched with mix: add this task before app.start
  """
  def run(_) do
    if Platformsh.Config.is_valid_platform?() do
      config = Platformsh.Config.config(Mix.Project.config()[:platformsh_config] || :all)
      Application.put_all_env(config)
    else
      Logger.warn("Trying to load Platform.sh Config but environment not detected")
    end
  end
  :ok
end

defmodule Mix.Tasks.Platformsh.Run do
  require Logger

  @moduledoc """
  hard alias to config+run for convenience
  """
  @doc """
  Platform.sh config+run task
  """
  def run(args) do
    if Platformsh.Config.is_valid_platform?() do
      Mix.Task.run("platformsh.config", args)
    else
      Logger.warn("Trying to run Platform.sh Mix task but environment not detected")
    end
    Mix.Task.run("run", args)
  end
end

defmodule Mix.Tasks.Platformsh.Compile do
  require Logger
  @moduledoc """
  hard alias to config+compile for convenience
  """
  @doc """
     Platform.sh config+compile task
  """
  def run(args) do
    if Platformsh.Config.is_valid_platform?() do
      Mix.Task.run("platformsh.config", args)
    else
      Logger.warn("Trying to run Platform.sh Mix task but environment not detected")
    end
    Mix.Task.run("compile", args)
  end
end

defmodule Mix.Tasks.Compile.PlatformshConf do
  require Logger
  @moduledoc """
  mix compiler adding config to compile for convenience
  """
  @doc """
     Platform.sh config for compile task
  """
  def run(_) do
    if Platformsh.Config.is_valid_platform?() do
      Mix.Task.run("platformsh.config", [])
    else
      Logger.warn("Trying to run Platform.sh Mix task but environment not detected")
    end
	:ok
  end
end
