defmodule Mix.Tasks.Cln do
  @shortdoc "Clean, deps, dialyzer and hex outdated"

  use Mix.Task

  @spec run(command_line_args :: [binary]) :: :ok
  def run(_args) do
    try do
      Mix.Tasks.Cmd.run(~w{rmdir /Q /S .elixir_ls})
    catch
      :exit, _reason -> :ok
    end

    try do
      Mix.Tasks.Cmd.run(~w{del mix.lock})
    catch
      :exit, _reason -> :ok
    end

    Mix.Tasks.Cmd.run(~w/mix clean/)
    Mix.Tasks.Cmd.run(~w/mix deps.clean --all/)
    Mix.Tasks.Cmd.run(~w/mix deps.unlock --all/)
    Mix.Tasks.Cmd.run(~w/mix deps.get/)
    Mix.Tasks.Cmd.run(~w/mix dialyzer/)
    Mix.Tasks.Cmd.run(~w/mix deps/)

    try do
      Mix.Tasks.Cmd.run(~w/mix hex.outdated/)
    catch
      :exit, _reason -> :ok
    end
  end
end
