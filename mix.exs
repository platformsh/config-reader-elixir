defmodule Platformshconfig.MixProject do
  use Mix.Project

  def project do
    [
      app: :platformshconfig,
	  name: "Platform.sh Config Reader",
	  description: description(),
      source_url: "https://github.com/platformsh/config-reader-elixir",
      homepage_url: "https://platform.sh",
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      package: package(),
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end
  
  defp description do
     """
     Platform.sh Config Reader
     """
   end

  defp deps do
    [
	 {:poison, "~> 3.0"},
	 {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end
  
  defp package do
    [
      organization: "platformsh",
	  maintainers: [
	        "Ori Pekelman",
	      ],
      files: ["lib", "mix.exs", "LICENSE", "CHANGELOG.md", "README.md"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/platformsh/config-reader-elixir",
      }
    ]
  end
  
end
