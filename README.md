# Mix Tasks

Custom mix tasks grouping standard mix tasks.

## Installation

Add `mix_tasks` to your list of dependencies in `mix.exs`:

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
- `mix esc`

Decrement patch version:
- `mix ver.dec`

Increment patch version:
- `mix ver.inc`

Get version number:
- `mix ver.get`
