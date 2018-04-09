# Mix Tasks

Custom mix tasks grouping standard mix tasks.

## Installation

Add the `:mix_tasks` dependency to your `mix.exs` file:

```elixir
def deps do
  [
    {:mix_tasks,
     github: "RaymondLoranger/mix_tasks", only: :dev, runtime: false}
  ]
end
```

## Usage

Clean, deps, dialyzer and hex outdated:
- `mix cln`

Format, compile, test, dialyzer and docs:
- `mix gen`

Format, compile, test, escript build, dialyzer and docs:
- 'mix esc`
