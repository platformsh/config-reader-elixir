defmodule PlatformshConfigTest do
  use ExUnit.Case

  setup do
    env_vars = [
      "PLATFORM_APPLICATION",
      "PLATFORM_APPLICATION_NAME",
      "PLATFORM_APP_COMMAND",
      "PLATFORM_APP_COMMAND",
      "PLATFORM_APP_DIR",
      "PLATFORM_BRANCH",
      "PLATFORM_DIR",
      "PLATFORM_DOCUMENT_ROOT",
      "PLATFORM_PROJECT",
      "PLATFORM_PROJECT_ENTROPY",
      "PLATFORM_TREE_ID",
      "PLATFORM_VARIABLES",
      "PLATFORM_RELATIONSHIPS",
      "PLATFORM_ENVIRONMENT"
    ]

    Enum.each(env_vars, fn x -> System.delete_env(x) end)

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
    System.put_env("PLATFORM_ENVIRONMENT", "master-7rqtwti")
    System.put_env("PLATFORM_PROJECT", "ehsumw32qasrm")

    System.put_env(
      "PLATFORM_PROJECT_ENTROPY",
      "UCFYORWWEWQO2KL4RJ2HXNR6JFOC7WL6AR756R46APAL5N32ETLA===="
    )

    System.put_env(
      "PLATFORM_RELATIONSHIPS",
      "eyJteXNxbGRiIjogW3sidXNlcm5hbWUiOiAidXNlciIsICJwYXNzd29yZCI6ICIiLCAic2VydmljZSI6ICJteXNxbGRiIiwgImlwIjogIjI0Ni4wLjk4LjExIiwgImNsdXN0ZXIiOiAidm13a2x6Y3BiaTZ6cS1tYXN0ZXIiLCAiaG9zdCI6ICJteXNxbGRiLmludGVybmFsIiwgInJlbCI6ICJteXNxbCIsICJxdWVyeSI6IHsiaXNfbWFzdGVyIjogdHJ1ZX0sICJwYXRoIjogIm1haW4iLCAic2NoZW1lIjogIm15c3FsIiwgInBvcnQiOiAzMzA2fV19"
    )

    System.put_env(
      "PLATFORM_ROUTES",
      "eyJodHRwczovL3d3dy5tYXN0ZXItN3JxdHd0aS1wNm1tb3o3d290cml3LmV1LTMucGxhdGZvcm1zaC5zaXRlLyI6IHsicHJpbWFyeSI6IGZhbHNlLCAiaWQiOiBudWxsLCAiYXR0cmlidXRlcyI6IHt9LCAidHlwZSI6ICJyZWRpcmVjdCIsICJ0byI6ICJodHRwczovL21hc3Rlci03cnF0d3RpLXA2bW1vejd3b3RyaXcuZXUtMy5wbGF0Zm9ybXNoLnNpdGUvIiwgIm9yaWdpbmFsX3VybCI6ICJodHRwczovL3d3dy57ZGVmYXVsdH0vIn0sICJodHRwOi8vbWFzdGVyLTdycXR3dGktcDZtbW96N3dvdHJpdy5ldS0zLnBsYXRmb3Jtc2guc2l0ZS8iOiB7InRvIjogImh0dHBzOi8vbWFzdGVyLTdycXR3dGktcDZtbW96N3dvdHJpdy5ldS0zLnBsYXRmb3Jtc2guc2l0ZS8iLCAib3JpZ2luYWxfdXJsIjogImh0dHA6Ly97ZGVmYXVsdH0vIiwgInR5cGUiOiAicmVkaXJlY3QiLCAicHJpbWFyeSI6IGZhbHNlLCAiaWQiOiBudWxsfSwgImh0dHBzOi8vbWFzdGVyLTdycXR3dGktcDZtbW96N3dvdHJpdy5ldS0zLnBsYXRmb3Jtc2guc2l0ZS8iOiB7InByaW1hcnkiOiB0cnVlLCAiaWQiOiBudWxsLCAiYXR0cmlidXRlcyI6IHt9LCAidHlwZSI6ICJ1cHN0cmVhbSIsICJ1cHN0cmVhbSI6ICJhcHAiLCAib3JpZ2luYWxfdXJsIjogImh0dHBzOi8ve2RlZmF1bHR9LyJ9LCAiaHR0cDovL3d3dy5tYXN0ZXItN3JxdHd0aS1wNm1tb3o3d290cml3LmV1LTMucGxhdGZvcm1zaC5zaXRlLyI6IHsidG8iOiAiaHR0cHM6Ly93d3cubWFzdGVyLTdycXR3dGktcDZtbW96N3dvdHJpdy5ldS0zLnBsYXRmb3Jtc2guc2l0ZS8iLCAib3JpZ2luYWxfdXJsIjogImh0dHA6Ly93d3cue2RlZmF1bHR9LyIsICJ0eXBlIjogInJlZGlyZWN0IiwgInByaW1hcnkiOiBmYWxzZSwgImlkIjogbnVsbH19"
    )

    System.put_env("PLATFORM_SMTP_HOST", "246.0.96.1")
    System.put_env("PLATFORM_TREE_ID", "7d6652a22ba3474e8cf73782d2504b9f3fe44f83")
    System.put_env("PLATFORM_VARIABLES", Base.encode64("{}"))

    # Code.require_file "support/delete_env.exs", __DIR__
    # Code.require_file "support/runtime.exs", __DIR__
  end

  test 'Valid Platform' do
    assert Platformsh.Config.is_valid_platform?()
  end

  test 'On Production' do
    assert Platformsh.Config.on_production?()
  end

  test 'Has Mysql' do
    assert Map.has_key?(Platformsh.Config.credentials(), "mysqldb")
  end

  test 'DSN ecto formatter makes sense' do
    assert Platformsh.Config.credentials("mysqldb") == %{
             "cluster" => "vmwklzcpbi6zq-master",
             "host" => "mysqldb.internal",
             "ip" => "246.0.98.11",
             "password" => "",
             "path" => "main",
             "port" => 3306,
             "query" => %{"is_master" => true},
             "rel" => "mysql",
             "scheme" => "mysql",
             "service" => "mysqldb",
             "username" => "user"
           }

    cred = Platformsh.Config.credentials("mysqldb")
    assert Platformsh.Config.ecto_dsn_formatter(cred) == "ecto://user:@mysqldb.internal/main"
  end

  test 'Guessing relational database' do
    assert Platformsh.Config.guess_relational_database() == %{
             "cluster" => "vmwklzcpbi6zq-master",
             "host" => "mysqldb.internal",
             "ip" => "246.0.98.11",
             "password" => "",
             "path" => "main",
             "port" => 3306,
             "query" => %{"is_master" => true},
             "rel" => "mysql",
             "scheme" => "mysql",
             "service" => "mysqldb",
             "username" => "user"
           }
  end

  test 'Has primary route' do
    assert Platformsh.Config.primary_route() ==
             "https://master-7rqtwti-p6mmoz7wotriw.eu-3.platformsh.site/"
  end

  test 'Gives out a route when no primary route exists' do
    System.put_env(
      "PLATFORM_ROUTES",
      "eyJodHRwOi8vbWFzdGVyLXZtd2tsemNwYmk2enEuZXUucGxhdGZvcm0uc2gvIjogeyJ0eXBlIjogInVwc3RyZWFtIiwgInRscyI6IHsiY2xpZW50X2F1dGhlbnRpY2F0aW9uIjogbnVsbCwgIm1pbl92ZXJzaW9uIjogbnVsbCwgImNsaWVudF9jZXJ0aWZpY2F0ZV9hdXRob3JpdGllcyI6IFtdLCAic3RyaWN0X3RyYW5zcG9ydF9zZWN1cml0eSI6IHsicHJlbG9hZCI6IG51bGwsICJpbmNsdWRlX3N1YmRvbWFpbnMiOiBudWxsLCAiZW5hYmxlZCI6IG51bGx9fSwgImNhY2hlIjogeyJkZWZhdWx0X3R0bCI6IDAsICJjb29raWVzIjogWyIqIl0sICJlbmFibGVkIjogdHJ1ZSwgImhlYWRlcnMiOiBbIkFjY2VwdCIsICJBY2NlcHQtTGFuZ3VhZ2UiXX0sICJzc2kiOiB7ImVuYWJsZWQiOiBmYWxzZX0sICJ1cHN0cmVhbSI6ICJhcHAiLCAib3JpZ2luYWxfdXJsIjogImh0dHA6Ly97ZGVmYXVsdH0vIiwgInJlc3RyaWN0X3JvYm90cyI6IHRydWV9LCAiaHR0cHM6Ly9tYXN0ZXItdm13a2x6Y3BiaTZ6cS5ldS5wbGF0Zm9ybS5zaC8iOiB7InR5cGUiOiAidXBzdHJlYW0iLCAidGxzIjogeyJjbGllbnRfYXV0aGVudGljYXRpb24iOiBudWxsLCAibWluX3ZlcnNpb24iOiBudWxsLCAiY2xpZW50X2NlcnRpZmljYXRlX2F1dGhvcml0aWVzIjogW10sICJzdHJpY3RfdHJhbnNwb3J0X3NlY3VyaXR5IjogeyJwcmVsb2FkIjogbnVsbCwgImluY2x1ZGVfc3ViZG9tYWlucyI6IG51bGwsICJlbmFibGVkIjogbnVsbH19LCAiY2FjaGUiOiB7ImRlZmF1bHRfdHRsIjogMCwgImNvb2tpZXMiOiBbIioiXSwgImVuYWJsZWQiOiB0cnVlLCAiaGVhZGVycyI6IFsiQWNjZXB0IiwgIkFjY2VwdC1MYW5ndWFnZSJdfSwgInNzaSI6IHsiZW5hYmxlZCI6IGZhbHNlfSwgInVwc3RyZWFtIjogImFwcCIsICJvcmlnaW5hbF91cmwiOiAiaHR0cHM6Ly97ZGVmYXVsdH0vIiwgInJlc3RyaWN0X3JvYm90cyI6IHRydWV9LCAiaHR0cDovL3d3dy0tLW1hc3Rlci12bXdrbHpjcGJpNnpxLmV1LnBsYXRmb3JtLnNoLyI6IHsidHlwZSI6ICJyZWRpcmVjdCIsICJ0bHMiOiB7ImNsaWVudF9hdXRoZW50aWNhdGlvbiI6IG51bGwsICJtaW5fdmVyc2lvbiI6IG51bGwsICJjbGllbnRfY2VydGlmaWNhdGVfYXV0aG9yaXRpZXMiOiBbXSwgInN0cmljdF90cmFuc3BvcnRfc2VjdXJpdHkiOiB7InByZWxvYWQiOiBudWxsLCAiaW5jbHVkZV9zdWJkb21haW5zIjogbnVsbCwgImVuYWJsZWQiOiBudWxsfX0sICJ0byI6ICJodHRwOi8vbWFzdGVyLXZtd2tsemNwYmk2enEuZXUucGxhdGZvcm0uc2gvIiwgIm9yaWdpbmFsX3VybCI6ICJodHRwOi8vd3d3LntkZWZhdWx0fS8iLCAicmVzdHJpY3Rfcm9ib3RzIjogdHJ1ZX0sICJodHRwczovL3d3dy0tLW1hc3Rlci12bXdrbHpjcGJpNnpxLmV1LnBsYXRmb3JtLnNoLyI6IHsidHlwZSI6ICJyZWRpcmVjdCIsICJ0bHMiOiB7ImNsaWVudF9hdXRoZW50aWNhdGlvbiI6IG51bGwsICJtaW5fdmVyc2lvbiI6IG51bGwsICJjbGllbnRfY2VydGlmaWNhdGVfYXV0aG9yaXRpZXMiOiBbXSwgInN0cmljdF90cmFuc3BvcnRfc2VjdXJpdHkiOiB7InByZWxvYWQiOiBudWxsLCAiaW5jbHVkZV9zdWJkb21haW5zIjogbnVsbCwgImVuYWJsZWQiOiBudWxsfX0sICJ0byI6ICJodHRwOi8vbWFzdGVyLXZtd2tsemNwYmk2enEuZXUucGxhdGZvcm0uc2gvIiwgIm9yaWdpbmFsX3VybCI6ICJodHRwczovL3d3dy57ZGVmYXVsdH0vIiwgInJlc3RyaWN0X3JvYm90cyI6IHRydWV9fQ=="
    )

    assert Platformsh.Config.primary_route() == "http://master-vmwklzcpbi6zq.eu.platform.sh/"
  end
end
