defmodule Mix.Tasks.Esc do
  @shortdoc "Format, compile, test, escript build, dialyzer and docs"

  use Mix.Task

  @spec run(command_line_args :: [binary]) :: :ok
  def run(args) do
    unless "--no-format" in args, do: Mix.Tasks.Cmd.run(~w<mix format>)
    if "--inc" in args, do: Mix.Tasks.Cmd.run(~w<mix ver.inc>)
    if "--dec" in args, do: Mix.Tasks.Cmd.run(~w<mix ver.dec>)
    Mix.Tasks.Cmd.run(~w/mix compile/)
    Mix.Tasks.Cmd.run(~w/mix test/)
    Mix.Tasks.Cmd.run(~w/mix escript.build/)
    Mix.Tasks.Cmd.run(~w/mix dialyzer --no-check/)
    Mix.Tasks.Cmd.run(~w/mix docs/)
    Mix.Tasks.Cmd.run(~w/mix deps.tree --format dot/)
    Mix.Tasks.Cmd.run(~w<mix ver.get>)

    if "--inc" in args do
      Mix.Tasks.Cmd.run(~w<git add .>)
      Mix.Tasks.Cmd.run(~w<git commit -am "#{version()}">)
      Mix.Tasks.Cmd.run(~w<git push>)
      Mix.Tasks.Cmd.run(~w/mix escript.install/)
    end
  end

  ## Private functions

  @spec version :: String.t()
  defp version do
    {:ok, content} = File.read("mix.exs")

    [_full, major, minor, patch] =
      Regex.run(~r|version: "(\d+)\.(\d+)\.(\d+)"|, content)

    "#{major}.#{minor}.#{patch}"
  end
end
