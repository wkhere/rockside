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
    [ applications: [:cowboy, :plug] ]
  end

  # Returns the list of dependencies in the format:
  # { :foobar, git: "https://github.com/elixir-lang/foobar.git", tag: "0.1" }
  #
  # To specify particular versions, regardless of the tag, do:
  # { :barbat, "~> 0.1", github: "elixir-lang/barbat" }
  defp deps(:prod) do
    [ {:cowboy, github: "extend/cowboy"},
      {:plug, "~> 0.2.0", github: "elixir-lang/plug"},
    ]
  end

  defp deps(_), do: deps :prod
end
