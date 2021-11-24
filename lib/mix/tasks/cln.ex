defmodule Mix.Tasks.Cln do
  @moduledoc """
  - Deletes file `mix.lock` if present.
  - Deletes folder `deps` if present.
  - Deletes folder `_build` if present.
  - Deletes folder `.elixir_ls` if present.
  - Gets all dependencies.
  - Runs dialyzer.
  - Lists all dependencies and their status.
  - Shows outdated Hex deps for the current project.
  """

  @shortdoc "Clean, deps, dialyzer and hex outdated"

  use Mix.Task

  alias Mix.Tasks.Custom.Cmd

  @doc """
  Clean, deps, dialyzer and hex outdated.

  ## Examples

      mix cln
  """
  @impl Mix.Task
  @spec run(OptionParser.argv()) :: :ok
  def run(_args) do
    if File.exists?("mix.lock"), do: Cmd.run(~w<del mix.lock>)
    if File.exists?("deps/"), do: Cmd.run(~w<rmdir /Q /S deps>)
    if File.exists?("_build/"), do: Cmd.run(~w<rmdir /Q /S _build>)
    if File.exists?(".elixir_ls/"), do: Cmd.run(~w<rmdir /Q /S .elixir_ls>)
    Cmd.run(~w/mix deps.get/)

    try do
      Cmd.run(~w/mix dialyzer/)
    catch
      :exit, _reason -> :ok
    end

    Cmd.run(~w/mix deps/)

    try do
      Cmd.run(~w/mix hex.outdated/)
    catch
      :exit, _reason -> :ok
    end
  end
end
