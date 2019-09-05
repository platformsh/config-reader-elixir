defmodule PlatformshConfigNotPlatformTest do
  use ExUnit.Case

  setup do
    # FIXME: figure out how to run this before all suites  
    env_vars = ["PLATFORM_APPLICATION","PLATFORM_APPLICATION_NAME", "PLATFORM_APP_COMMAND","PLATFORM_APP_COMMAND","PLATFORM_APP_DIR","PLATFORM_BRANCH","PLATFORM_DIR", "PLATFORM_DOCUMENT_ROOT","PLATFORM_PROJECT", "PLATFORM_PROJECT_ENTROPY", "PLATFORM_TREE_ID", "PLATFORM_VARIABLES", "PLATFORM_RELATIONSHIPS", "PLATFORM_ENVIRONMENT"]
	Enum.each(env_vars, fn x -> System.delete_env x end)
  end

  test 'Valid Platform' do
    refute Platformsh.Config.is_valid_platform?()
  end

  test 'On Production' do
    refute Platformsh.Config.on_production?()
  end

  test 'Does not have Mysql' do
	  assert_raise BadMapError, fn ->
		  Map.has_key?(Platformsh.Config.credentials(), "mysqldb")
	  end
  end
end
