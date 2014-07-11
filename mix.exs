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
    [ description: 'Controllerless web architecture',
      applications: dep_apps ]
  end

  # Returns the list of dependencies in the format:
  # { :foobar, git: "https://github.com/elixir-lang/foobar.git", tag: "0.1" }
  #
  # To specify particular versions, regardless of the tag, do:
  # { :barbat, "~> 0.1", github: "elixir-lang/barbat" }
  defp deps do
    [ {:cowboy, github: "extend/cowboy"},
      {:plug, "== 0.5.1"},
      {:excoveralls, "== 0.2.2", only: :test},
      {:reprise, "== 0.1.3", only: :dev},
    ]
  end
end
