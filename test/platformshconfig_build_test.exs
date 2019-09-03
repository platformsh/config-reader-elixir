defmodule PlatformshConfigBuildTest do
  use ExUnit.Case

  setup do
    # FIXME: figure out how to run this before all suites  	  
    env_vars = ["PLATFORM_APPLICATION","PLATFORM_APPLICATION_NAME", "PLATFORM_APP_COMMAND","PLATFORM_APP_COMMAND","PLATFORM_APP_DIR","PLATFORM_BRANCH","PLATFORM_DIR", "PLATFORM_DOCUMENT_ROOT","PLATFORM_PROJECT", "PLATFORM_PROJECT_ENTROPY", "PLATFORM_TREE_ID", "PLATFORM_VARIABLES", "PLATFORM_RELATIONSHIPS", "PLATFORM_ENVIRONMENT"]
	Enum.each(env_vars, fn x -> System.delete_env x end)
	  
    System.put_env(
      "PLATFORM_APPLICATION",
      "eyJzaXplIjogIkFVVE8iLCAiZGlzayI6IDIwNDgsICJhY2Nlc3MiOiB7InNzaCI6ICJjb250cmlidXRvciJ9LCAicmVsYXRpb25zaGlwcyI6IHsibXlzcWxkYiI6ICJteXNxbGRiOm15c3FsIn0sICJtb3VudHMiOiB7Ii93ZWIvc2l0ZXMvZGVmYXVsdC9maWxlcyI6IHsic291cmNlIjogImxvY2FsIiwgInNvdXJjZV9wYXRoIjogImZpbGVzIn0sICIvdG1wIjogeyJzb3VyY2UiOiAibG9jYWwiLCAic291cmNlX3BhdGgiOiAidG1wIn0sICIvcHJpdmF0ZSI6IHsic291cmNlIjogImxvY2FsIiwgInNvdXJjZV9wYXRoIjogInByaXZhdGUifSwgIi9kcnVzaC1iYWNrdXBzIjogeyJzb3VyY2UiOiAibG9jYWwiLCAic291cmNlX3BhdGgiOiAiZHJ1c2gtYmFja3VwcyJ9fSwgInRpbWV6b25lIjogbnVsbCwgInZhcmlhYmxlcyI6IHt9LCAibmFtZSI6ICJhcHAiLCAidHlwZSI6ICJwaHA6Ny4xIiwgInJ1bnRpbWUiOiB7fSwgInByZWZsaWdodCI6IHsiZW5hYmxlZCI6IHRydWUsICJpZ25vcmVkX3J1bGVzIjogW119LCAid2ViIjogeyJsb2NhdGlvbnMiOiB7Ii8iOiB7InJvb3QiOiAid2ViIiwgImV4cGlyZXMiOiAiNW0iLCAicGFzc3RocnUiOiAiL2luZGV4LnBocCIsICJzY3JpcHRzIjogdHJ1ZSwgImFsbG93IjogZmFsc2UsICJoZWFkZXJzIjoge30sICJydWxlcyI6IHsiXFwuKGpwZT9nfHBuZ3xnaWZ8c3Znej98Y3NzfGpzfG1hcHxpY298Ym1wfGVvdHx3b2ZmMj98b3RmfHR0ZikkIjogeyJhbGxvdyI6IHRydWV9LCAiXi9yb2JvdHNcXC50eHQkIjogeyJhbGxvdyI6IHRydWV9LCAiXi9zaXRlbWFwXFwueG1sJCI6IHsiYWxsb3ciOiB0cnVlfX19LCAiL3NpdGVzL2RlZmF1bHQvZmlsZXMiOiB7InJvb3QiOiAid2ViL3NpdGVzL2RlZmF1bHQvZmlsZXMiLCAiZXhwaXJlcyI6ICI1bSIsICJwYXNzdGhydSI6ICIvaW5kZXgucGhwIiwgInNjcmlwdHMiOiBmYWxzZSwgImFsbG93IjogdHJ1ZSwgImhlYWRlcnMiOiB7fSwgInJ1bGVzIjogeyJeL3NpdGVzL2RlZmF1bHQvZmlsZXMvKGNzc3xqcykiOiB7ImV4cGlyZXMiOiAiMncifX19fSwgIm1vdmVfdG9fcm9vdCI6IGZhbHNlfSwgImhvb2tzIjogeyJidWlsZCI6IG51bGwsICJkZXBsb3kiOiAiY2Qgd2ViXG5kcnVzaCAteSBjYWNoZS1yZWJ1aWxkXG5kcnVzaCAteSB1cGRhdGVkYlxuZHJ1c2ggLXkgY29uZmlnLWltcG9ydFxuZHJ1c2ggLXkgZW50dXBcbiIsICJwb3N0X2RlcGxveSI6IG51bGx9fQ=="
    )
    System.put_env("PLATFORM_APPLICATION_NAME", "app")
    System.put_env("PLATFORM_APP_COMMAND", "sleep infinity")
    System.put_env("PLATFORM_APP_DIR", "/app")
    System.put_env("PLATFORM_BRANCH", "master")
    System.put_env("PLATFORM_DIR", "/app")
    System.put_env("PLATFORM_DOCUMENT_ROOT", "/app/public")
    System.put_env("PLATFORM_PROJECT", "ehsumw32qasrm")

    System.put_env(
      "PLATFORM_PROJECT_ENTROPY",
      "UCFYORWWEWQO2KL4RJ2HXNR6JFOC7WL6AR756R46APAL5N32ETLA===="
    )

    System.put_env("PLATFORM_TREE_ID", "7d6652a22ba3474e8cf73782d2504b9f3fe44f83")
    System.put_env("PLATFORM_VARIABLES", Base.encode64("{}"))
  end

  test 'Valid Platform' do
    assert Platformsh.Config.is_valid_platform?()
  end

  test 'On Production branch' do
    assert Platformsh.Config.on_production?()
  end

  test 'In Build' do
    assert Platformsh.Config.in_build?()
  end

  test 'Does not have Mysql' do
	  assert_raise BadMapError, fn ->
		  Map.has_key?(Platformsh.Config.credentials(), "mysqldb")
	  end
  end
end
