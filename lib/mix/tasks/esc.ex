defmodule Mix.Tasks.Esc do
  @shortdoc "Compiles, tests, builds escript, runs dialyzer and docs"

  use Mix.Task

  @spec run(OptionParser.argv) :: :ok
  def run(_args) do
    Mix.Tasks.Cmd.run ~w/mix compile/
    Mix.Tasks.Cmd.run ~w/mix test/
    Mix.Tasks.Cmd.run ~w/mix escript.build/
    Mix.Tasks.Cmd.run ~w/mix dialyzer --no-check/
    Mix.Tasks.Cmd.run ~w/mix docs/
  end
end
