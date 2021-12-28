defmodule Mix.Tasks.Gen do
  @moduledoc """
  - Increments the app version if option `--inc` specified.
  - Decrements the app version if option `--dec` specified.
  - Formats the given files and patterns unless option `--no-format` specified.
  - Compiles source files.
  - Runs the project's tests.
  - Builds an escript for the project if applicable.
  - Runs dialyzer.
  - Generates documentation for the project.
  - Shows outdated Hex deps for the current project.
  - Produces a DOT graph description of the dependency tree.
  - Prints the app version.
  - Performs a `git push` if option `--inc` specified.
  - Installs an escript locally if applicable and option `--inc` specified.

  ## Command line options

    * `--no-format` - prevents formatting the given files and patterns
    * `--inc` - increments the app version, performs a `git push` and
         installs an escript locally if applicable
    * `--dec` - decrements the app version
  """

  @shortdoc "Format, compile, test, dialyzer, docs, git push and escript"

  use Mix.Task

  alias Mix.Tasks.Custom.Cmd

  @doc """
  Format, compile, test, dialyzer, docs, `git push` and escript.

  ## Examples

      mix gen
      mix gen --inc
      mix gen --no-format
  """
  @impl Mix.Task
  @spec run(OptionParser.argv()) :: :ok
  def run(args) do
    escript? = !is_nil(Mix.Project.config()[:escript])
    %Version{} = version = Mix.Project.config()[:version] |> Version.parse!()

    version =
      if "--inc" in args do
        Cmd.run(~w<mix ver.inc>)
        update_in(version.patch, &(&1 + 1))
      else
        version
      end

    version =
      if "--dec" in args do
        Cmd.run(~w<mix ver.dec>)
        update_in(version.patch, &(&1 - 1))
      else
        version
      end

    unless "--no-format" in args do
      try do
        Cmd.run(~w<mix format>)
      catch
        :exit, _reason -> :ok
      end
    end

    Cmd.run(~w/mix compile/)
    Cmd.run(~w/mix test/)
    if escript?, do: Cmd.run(~w/mix escript.build/)

    try do
      Cmd.run(~w/mix dialyzer --no-check --quiet/)
    catch
      :exit, _reason -> :ok
    end

    try do
      Cmd.run(~w/mix docs/)
    catch
      :exit, _reason -> :ok
    end

    try do
      Cmd.run(~w/mix hex.outdated/)
    catch
      :exit, _reason -> :ok
    end

    Cmd.run(~w/mix deps.tree --format dot/)
    Cmd.run(~w<mix ver>)

    if "--inc" in args do
      Cmd.run(~w<git add .>)
      Cmd.run(~w<git commit -am "#{version}">)

      try do
        Cmd.run(~w<git push>)
      catch
        :exit, _reason -> :ok
      end

      if escript?, do: Cmd.run(~w/mix escript.install --force/)
    end
  end
end
