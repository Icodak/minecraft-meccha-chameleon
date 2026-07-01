# meccha:game/set_hide_time   (macro: $(seconds))
# Customise the hide window (hunter blindness duration).
$data modify storage meccha:settings hide_seconds set value $(seconds)
$tellraw @s [{"text":"[Meccha] ","color":"green"},{"text":"hide time = $(seconds)s","color":"gray"}]
