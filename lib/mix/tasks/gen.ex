defmodule Mix.Tasks.Gen do
  @moduledoc """
  - Increments the app version if option `--inc` specified.
  - Decrements the app version if option `--dec` specified.
  - Formats the configured files unless option `--no-format` specified.
  - Compiles source files.
  - Runs the project's tests.
  - Builds an escript for the project if applicable.
  - Runs dialyzer if applicable.
  - Generates documentation for the project if applicable.
  - Shows outdated Hex deps for the current project.
  - Produces a DOT graph description of the dependency tree.
  - Prints the app version.
  - Performs `git push` if option `--inc` specified.
  - Installs an escript locally if applicable and option `--inc` specified.
  - Performs `git branch`

  ## Command line options

    * `--force` - forces compilation
    * `--no-format` - prevents formatting the configured files
    * `--inc` - increments the app version, performs `git push` and
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
      mix gen --force
  """
  @impl Mix.Task
  @spec run(OptionParser.argv()) :: :ok
  def run(args) do
    escript? = !is_nil(Mix.Project.config()[:escript])
    phoenix? = :phoenix in Mix.Project.deps_apps()
    docs? = :ex_doc in Mix.Project.deps_apps()
    dialyxir? = :dialyxir in Mix.Project.deps_apps()
    git? = File.exists?(".git/")
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

    if "--force" in args do
      Cmd.run(~w/mix compile --force/)
      Cmd.run(~w/elixir --color -S mix test --force/)
    else
      Cmd.run(~w/mix compile/)
      Cmd.run(~w/elixir --color -S mix test/)
    end

    if escript?, do: Cmd.run(~w/mix escript.build/)

    try do
      if dialyxir?, do: Cmd.run(~w/mix dialyzer --no-check --quiet/)
    catch
      :exit, _reason -> :ok
    end

    if docs?, do: Cmd.run(~w/mix docs/)

    try do
      unless phoenix?, do: Cmd.run(~w/elixir --color -S mix hex.outdated/)
    catch
      :exit, _reason -> :ok
    end

    Cmd.run(~w/mix deps.tree --format dot/)
    Cmd.run(~w<elixir --color -S mix ver>)

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

    if git?, do: Cmd.run(~w<git branch>)
  end
end
