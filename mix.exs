defmodule Rockside.Mixfile do
  use Mix.Project

  def project do
    [ app: :rockside,
      version: "0.0.1",
      elixir: "~> 0.12.2",
      deps: deps Mix.env ]
  end

  # Configuration for the OTP application
  def application do
    dep_apps = [:cowboy, :plug]
    if Mix.env == :dev, do: dep_apps = [:exreloader | dep_apps]
    [ applications: dep_apps ]
  end

  # Returns the list of dependencies in the format:
  # { :foobar, git: "https://github.com/elixir-lang/foobar.git", tag: "0.1" }
  #
  # To specify particular versions, regardless of the tag, do:
  # { :barbat, "~> 0.1", github: "elixir-lang/barbat" }
  defp deps(:prod) do
    [ {:cowboy, github: "extend/cowboy"},
      {:plug, "== 0.2.0", github: "herenowcoder/plug"},
    ]
  end

  defp deps(:dev) do
    [ {:exreloader, github: "herenowcoder/exreloader"}
      | deps :prod ]
  end

  defp deps(_), do: deps :prod
end
