# meccha:init/game_defaults
# Round settings + game state. Guarded so operator changes and a live round
# survive /reload. Call from load only via `unless data` checks.

# Customisable round settings.
execute unless data storage meccha:settings hide_seconds run data merge storage meccha:settings {hide_seconds:45, round_seconds:300, freeze_hunters:1b}

# Game state machine. phase: idle | hiding | hunting | over.
execute unless data storage meccha:game phase run data merge storage meccha:game {phase:"idle", timer:0}
