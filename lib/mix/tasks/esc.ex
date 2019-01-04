defmodule Mix.Tasks.Esc do
  @shortdoc "Format, compile, test, escript build, dialyzer and docs"

  use Mix.Task

  @spec run(OptionParser.argv()) :: :ok
  def run(args) do
    unless "--no-format" in args, do: Mix.Tasks.Cmd.run(~w<mix format>)
    if "--inc" in args, do: Mix.Tasks.Cmd.run(~w<mix ver.inc>)
    if "--dec" in args, do: Mix.Tasks.Cmd.run(~w<mix ver.dec>)
    Mix.Tasks.Cmd.run(~w/mix compile/)
    Mix.Tasks.Cmd.run(~w/mix test/)
    Mix.Tasks.Cmd.run(~w/mix escript.build/)
    Mix.Tasks.Cmd.run(~w/mix dialyzer --no-check/)
    Mix.Tasks.Cmd.run(~w/mix docs/)
    Mix.Tasks.Cmd.run(~w<mix ver.get>)
  end
end
