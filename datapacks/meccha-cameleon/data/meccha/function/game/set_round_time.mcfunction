# meccha:game/set_round_time   (macro: $(seconds))
# Customise the hunt duration.
$data modify storage meccha:settings round_seconds set value $(seconds)
$tellraw @s [{"text":"[Meccha] ","color":"green"},{"text":"round time = $(seconds)s","color":"gray"}]
