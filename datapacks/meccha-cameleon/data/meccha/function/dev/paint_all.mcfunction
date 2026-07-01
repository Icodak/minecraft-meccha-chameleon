# meccha:dev/paint_all   (macro: $(color))
# Flood the whole rig with one colour.
$data modify storage meccha:rt col.hex set value "$(color)"
function meccha:lib/color/hex_to_argb
execute as @e[type=text_display,tag=meccha_pixel] run function meccha:paintbrush/apply_color
$tellraw @s [{"text":"[dev] ","color":"green"},{"text":"painted rig $(color)","color":"gray"}]
