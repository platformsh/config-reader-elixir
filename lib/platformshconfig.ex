defmodule Platformsh do
  defmodule Get do
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
      get/1 Reads unprefixed environment variable, taking the prefix into account.
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
      get/2 Reads an environment variable, taking the prefix into account.
        Args:
           item (string):
               The variable to read.
    """
    def value(item, env_prefix) do
      directVariables = %{
        project: "PROJECT",
        app_dir: "APP_DIR",
        application_name: 'APPLICATION_NAME',
        tree_id: "TREE_ID",
        project_entropy: "PROJECT_ENTROPY"
      }

      # Local index of the variables that can be accessed as direct properties
      # (runtime only). The key is the property that will be read. The value is the environment variables, minus
      # prefix, that contains the value to look up.

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
          Platformsh.Get.decode(System.get_env("#{env_prefix}#{inDirectVariablesRuntime[item]}"))

        True ->
          False
      end
    end
  end
end

defmodule Platformsh do
  defmodule Environment do
    alias Platformsh.Get, as: Get

    @doc """
    Local index of the variables that can be accessed as direct properties (build and
    runtime). The key is the property that will be read. The value is the environment variables, minus prefix,
    that contains the value to look up.
    """

    def environment() do
      env_prefix = 'PLATFORM_'

      %{
        project: Get.value(:project, env_prefix),
        appDir: Get.value(:app_dir, env_prefix),
        applicationName: Get.value(:application_name, env_prefix),
        treeID: Get.value(:tree_id, env_prefix),
        projectEntropy: Get.value(:project_entropy, env_prefix),
        mode: Get.value(:mode, env_prefix),

        # Local index of the variables that can be accessed as direct properties
        # (runtime only). The key is the property that will be read. The value
        # is the environment variables, minus prefix, that contains the value to
        # look up.
        branch: Get.value(:branch, env_prefix),
        environment: Get.value(:environment, env_prefix),
        documentRoot: Get.value(:document_root, env_prefix),
        smtpHost: Get.value(:smtp_host, env_prefix),

        # Local index of variables available at runtime that have no prefix.
        port: Get.value(:port),
        socket: Get.value(:socket),

        # Local index of variables available at runtime that need decoding
        routes: Get.value(:routes, env_prefix),
        relationships: Get.value(:relationships, env_prefix),
        application: Get.value(:application, env_prefix),
        variables: Get.value(:variables, env_prefix)
      }
    end
  end
end

defmodule Platformsh do
  alias Platformsh.Environment, as: Environment

  defmodule Config do
    @moduledoc """
    	Reads Platform.sh configuration from environment variables.
    	See: https://docs.platform.sh/development/variables.html
    	The following are 'magic' properties that may exist on a Config object. Before accessing a property, check its
    	existence with hasattr(config, variableName). Attempting to access a nonexistent variable will throw an exception.
    	Attributes:
    	    (The following properties are available at build time and run time.)
    	    project (string):
    	        The project ID.
    	    applicationName (string):
    	        The name of the application, as defined in its configuration.
    	    treeID (string):
    	        An ID identifying the application tree before it was built: a unique hash is generated based on the contents
    	        of the application's files in the repository.
    	    appDir (string):
    	        The absolute path to the application.
    	    projectEntropy (string):
    	        A random string generated for each project, useful for generating hash keys.
    	    (The following properties are only available at runtime.)
    	    branch (string):
    	        The Git branch name.
    	    environment (string):
    	        The environment ID (usually the Git branch plus a hash).
    	    documentRoot (string):
    	        The absolute path to the web root of the application.
    	    smtpHost (string):
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
    Checks whether the code is running on a platform with valid environment variables.
    Returns:
        bool:
            True if configuration can be used, False otherwise.
    """
    def is_valid_platform?() do
      Environment.environment()[:application_name] != nil
    end

    @doc """
    Checks whether the code is running in a build environment.
    Returns:
        bool: True if running in build environment, False otherwise.
    """
    def in_build?() do
      is_valid_platform? and Environment.environment()[:environment] != nil
    end

    @doc """
    Checks whether the code is running in a runtime environment.
    Returns:
        bool: True if in a runtime environment, False otherwise.
    """
    def in_runtime?() do
      is_valid_platform? and !Environment.environment()[:environment] != nil
    end

    @doc """
    Retrieves the credentials for accessing a relationship.
    Args:
        relationship (string):
            The relationship name as defined in .platform.app.yaml
        index (int):
            The index within the relationship to access. This is always 0, but reserved for future extension.
    Returns:
        The credentials dict for the service pointed to by the relationship.
    Raises:
        RuntimeError:
            Thrown if called in a context that has no relationships (eg, in build).
        KeyError:
            Thrown if the relationship/index pair requested does not exist.
    """
    def credentials(relationship) do
      [config | _tail] = Environment.environment()[:relationships][relationship]
      config
    end

    @doc """
    Returns a variable from the VARIABLES dict.
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
        The value of the variable, or the specified default. This may be a string or a dict.
    """
    def variable(name) do
      if Map.has_key?(Environment.environment()[:variables], name) do
        Environment.environment()[:variables][name]
      else
        nil
      end
    end

    @doc """
    Returns the full variables dict.
    If you're looking for a specific variable, the variable() method is a more robust option.
    This method is for classes where you want to scan the whole variables list looking for a pattern.
    It's valid for there to be no variables defined at all, so there's no guard for missing values.
    Returns:
        The full variables dict.
    """
    def variables() do
      Environment.environment()[:variables]
    end

    @doc """
    Return the routes definition.
    Returns:
        The routes dict.
    Raises:
        RuntimeError:
            If the routes are not accessible due to being in the wrong environment.
    """
    def routes() do
      Environment.environment()[:routes]
    end

    @doc """
    Get route definition by route ID.
    Args:
        route_id (string):
            The ID of the route to load.
    Returns:
        The route definition. The generated URL of the route is added as a 'url' key.
    Raises:
        KeyError:
            If there is no route by that ID, an exception is thrown.
    """
    def get_route(route_id) do
      Environment.environment()[:routes][route_id]
    end

    @doc """
    Returns the application definition dict.
    This is, approximately, the .platform.app.yaml file as a nested dict. However, it also has other information
    added by Platform.sh as part of the build and deploy process.
    Returns:
        The application definition dict.
    """
    def application() do
      Environment.environment()[:application]
    end

    @doc """
    Determines if the current environment is a Platform.sh Enterprise environment.
    Returns:
        bool:
            True on an Enterprise environment, False otherwise.
    """
    def on_enterprise?() do
      is_valid_platform? and Environment.environment()[:mode] == 'enterprise'
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
    def on_production() do
      if !is_valid_platform? and !in_build? do
        False
      else
        prod_branch = if on_enterprise?, do: 'production', else: 'master'
        Environment.environment()[:branch] == prod_branch
      end
    end

    @doc """
    Determines if a routes are defined
    Returns:
        bool:
            True if the relationship is defined, False otherwise.
    """
    def has_routes?() do
      Environment.environment()[:routes] != nil
    end

    @doc """
    Determines if a relationships are defined, and thus has credentials available.
    Returns:
        bool:
            True if the relationship is defined, False otherwise.
    """
    def has_relationships() do
      Environment.environment()[:relationships] != nil
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
      Map.has_key?(Environment.environment()[:relationships], relationship)
    end
	
    @doc """
    Returns the full variables dict.
    If you're looking for a specific variable, the variable() method is a more robust option.
    This method is for classes where you want to scan the whole variables list looking for a pattern.
    It's valid for there to be no variables defined at all, so there's no guard for missing values.
    Returns:
        The full variables dict.
    """
    def relationships() do
      Map.keys(Environment.environment()[:relationships])
    end
  end
end
