# Mix Tasks

Custom mix tasks grouping standard mix tasks.

## Installation

Clone `mix_tasks` and then compile and archive it:

```
git clone https://github.com/RaymondLoranger/mix_tasks
cd mix_tasks
mix deps.get
mix compile
mix archive.install
```

## Usage

Clean, deps, dialyzer and hex outdated:
- `mix cln`

Format, compile, test, dialyzer, docs, git push and escript:
- `mix gen`
- `mix gen --inc`
- `mix gen --no-format`
- `mix gen --force`

Decrements the app version:
- `mix ver.dec`

Increments the app version:
- `mix ver.inc`

Prints the app version:
- `mix ver`
