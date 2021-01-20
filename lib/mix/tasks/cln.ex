defmodule Mix.Tasks.Cln do
  @shortdoc "Clean, deps, dialyzer and hex outdated"

  use Mix.Task

  @spec run(command_line_args :: [binary]) :: :ok
  def run(_args) do
    do_run(~w/mix deps.update --all/)
    do_run(~w/mix clean/)
    do_run(~w/mix deps.clean --all/)
    do_run(~w/mix deps.unlock --all/)
    do_run(~w/mix deps.get/)
    do_run(~w/mix dialyzer/)
    do_run(~w/mix deps/)

    try do
      do_run(~w/mix hex.outdated/)
    catch
      :exit, _reason -> :ok
    end
  end

  @spec do_run([String.t()]) :: :ok
  defp do_run(cmd) do
    IO.ANSI.format([:light_yellow, Enum.join(cmd, " ")]) |> IO.puts()
    Mix.Tasks.Cmd.run(cmd)
  end
end
