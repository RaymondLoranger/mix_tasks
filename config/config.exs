# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# Mix messages in colors...
config :elixir, ansi_enabled: true

config :io_ansi_table, align_specs: [center: :hex]
config :io_ansi_table, bell: false
config :io_ansi_table, count: 55

config :io_ansi_table,
  headers: [
    :rank,
    :chunk,
    :ver,
    :hex,
    :app,
    :deps,
    :dependent_1,
    :dependent_2,
    :dependent_3,
    :dependent_4
  ]

config :io_ansi_table, header_fixes: %{~r/^hex$/i => "Hex?"}
config :io_ansi_table, margins: [top: 0, left: 0, bottom: 0]
config :io_ansi_table, sort_specs: [:rank, :chunk, :app]
config :io_ansi_table, style: :plain

#     import_config "#{Mix.env}.exs"
