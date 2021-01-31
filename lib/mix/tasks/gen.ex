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
    if escript?(), do: do_run(~w/mix escript.build/)

    try do
      do_run(~w/mix dialyzer --no-check/)
    catch
      :exit, _reason -> :ok
    end

    try do
      do_run(~w/mix docs/)
    catch
      :exit, _reason -> :ok
    end

    do_run(~w/mix deps.tree --format dot/)
    do_run(~w<mix ver.get>)

    if "--inc" in args do
      do_run(~w<git add .>)
      do_run(~w<git commit -am "#{version()}">)

      try do
        do_run(~w<git push>)
      catch
        :exit, _reason -> :ok
      end

      if escript?(), do: do_run(~w/mix escript.install --force/)
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

  @spec escript? :: boolean
  defp escript? do
    {:ok, content} = File.read("mix.exs")
    content =~ "escript:"
  end

  @spec do_run([String.t()]) :: :ok
  defp do_run(cmd) do
    IO.ANSI.format([:light_yellow, Enum.join(cmd, " ")]) |> IO.puts()
    Mix.Tasks.Cmd.run(cmd)
  end
end
