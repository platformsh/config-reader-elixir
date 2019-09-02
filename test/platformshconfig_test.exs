ExUnit.start()

defmodule PlatformshConfigTest do
  use ExUnit.Case
  doctest Platformsh.Config
  alias Platformsh.Config, as: Config
  
  setup do 
	System.put_env("PLATFORM_APPLICATION", Base.encode64("{}"))
	System.put_env("PLATFORM_APPLICATION_NAME", "myrubyapp")
	System.put_env("PLATFORM_APP_COMMAND", "unicorn -l \$SOCKET -E production config.ru")
	System.put_env("PLATFORM_APP_DIR", "/app")
	System.put_env("PLATFORM_BRANCH", "master")
	System.put_env("PLATFORM_DIR", "/app")
	System.put_env("PLATFORM_DOCUMENT_ROOT", "/app/public")
	System.put_env("PLATFORM_ENVIRONMENT", "master-7rqtwti")
	System.put_env("PLATFORM_PROJECT", "ehsumw32qasrm")
	System.put_env("PLATFORM_PROJECT_ENTROPY", Base.encode64("{}"))
	System.put_env("PLATFORM_RELATIONSHIPS", Base.encode64("{}"))
	System.put_env("PLATFORM_ROUTES", Base.encode64("{}"))
	System.put_env("PLATFORM_SMTP_HOST", Base.encode64("{}"))
	System.put_env("PLATFORM_TREE_ID", "7d6652a22ba3474e8cf73782d2504b9f3fe44f83")
	System.put_env("PLATFORM_VARIABLES", Base.encode64("{}"))
  end

  test "Valid Platform" do
	  assert Config.is_valid_platform?
  end
  
  test "On Production" do
	  assert Config.on_production?
  end

  test "Has Mysql" do
	  assert  Map.has_key?(Config.relationships(), "mysql")
  end

end
