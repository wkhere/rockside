defmodule Rockside.Mixfile do
  use Mix.Project

  def project do
    [ app: :rockside,
      version: "0.0.2",
      elixir: "~> 0.14.2",
      deps: deps,
      test_coverage: [tool: ExCoveralls]
    ]
  end

  # Configuration for the OTP application
  def application do
    dep_apps = [:cowboy, :plug]
    if Mix.env == :dev, do: dep_apps = [:reprise | dep_apps]
    [ applications: dep_apps ]
  end

  # Returns the list of dependencies in the format:
  # { :foobar, git: "https://github.com/elixir-lang/foobar.git", tag: "0.1" }
  #
  # To specify particular versions, regardless of the tag, do:
  # { :barbat, "~> 0.1", github: "elixir-lang/barbat" }
  defp deps do
    [ {:cowboy, github: "extend/cowboy"},
      {:plug, "== 0.5.1", github: "elixir-lang/plug", tag: "v0.5.1"},
      {:excoveralls, github: "parroty/excoveralls", tag: "v0.2.3", only: :test},
      {:reprise, github: "herenowcoder/reprise", tag: "v0.1.0", only: :dev},
    ]
  end
end
