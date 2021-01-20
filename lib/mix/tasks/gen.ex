defmodule Mix.Tasks.Gen do
  @shortdoc "Format, compile, test, dialyzer and docs"

  use Mix.Task

  @spec run(command_line_args :: [binary]) :: :ok
  def run(args) do
    unless "--no-format" in args, do: do_run(~w<mix format>)
    if "--inc" in args, do: do_run(~w<mix ver.inc>)
    if "--dec" in args, do: do_run(~w<mix ver.dec>)
    do_run(~w/mix compile/)
    do_run(~w/mix test/)
    do_run(~w/mix dialyzer --no-check/)
    do_run(~w/mix docs/)
    do_run(~w/mix deps.tree --format dot/)
    do_run(~w<mix ver.get>)

    if "--inc" in args or "--replace" in args do
      do_run(~w<git add .>)
      do_run(~w<git commit -am "#{version()}">)
      do_run(~w<git push>)

      if "--replace" in args,
        do: do_run(~w<mix hex.publish --yes --replace>),
        else: do_run(~w<mix hex.publish --yes>)
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

  @spec do_run([String.t()]) :: :ok
  defp do_run(cmd) do
    IO.ANSI.format([:light_yellow, cmd]) |> IO.puts()
    Mix.Tasks.Cmd.run(cmd)
  end
end
