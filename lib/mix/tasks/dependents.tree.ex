defmodule Mix.Tasks.Dependents.Tree do
  use Mix.Task

  alias IO.ANSI.Table
  alias Mix.Tasks.Dependents.Tree.{Adaptor, Digraph, Parser}

  @shortdoc "Prints the dependents tree"

  @spec run(command_line_args :: [binary]) :: :ok
  def run(["--all"] = _args) do
    Table.App.start(:normal, :ok)
    tree = Parser.dependents_tree()
    digraph = Digraph.from_tree(tree)
    ranks = Digraph.ranks(digraph)

    tree
    |> Adaptor.tree_to_maps(ranks)
    |> Table.format()
  end

  def run([app | _rest] = _args) do
    Table.App.start(:normal, :ok)
    app = String.to_atom(app)
    tree = Parser.dependents_tree()
    digraph = Digraph.from_tree(tree)
    ranks = Digraph.ranks(digraph)
    deps = Digraph.dependents(app, digraph)

    tree
    |> Map.take([app | deps])
    |> Adaptor.tree_to_maps(ranks)
    |> Table.format()
  end
end
