# meccha:dev/paint_all   (macro: $(color))
# Flood the whole rig with one color.
$data modify storage meccha:rt col.hex set value "$(color)"
$execute as @e[type=text_display,tag=meccha_pixel] run function meccha:paintbrush/apply_color {color:"$(color)"}
$tellraw @s [{"text":"[dev] ","color":"green"},{"text":"painted rig $(color)","color":"gray"}]
