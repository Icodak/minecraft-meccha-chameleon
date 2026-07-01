# meccha:game/blind_hunters   (macro: $(hide_seconds))
# Hide hunter vision (blindness + darkness) and optionally freeze them in place
# for the configured hide window. Effects are ambient (hidden particles) and
# the duration matches the round setting, so no per-tick reapplication needed.
$effect give @a[tag=meccha_hunter] minecraft:blindness $(hide_seconds) 0 true
$effect give @a[tag=meccha_hunter] minecraft:darkness $(hide_seconds) 0 true
execute if data storage meccha:settings {freeze_hunters:1b} run function meccha:game/freeze_hunters with storage meccha:settings
