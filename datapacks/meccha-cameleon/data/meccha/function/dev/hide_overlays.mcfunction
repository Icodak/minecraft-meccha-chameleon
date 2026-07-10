# meccha:dev/hide_overlays
# Make shading overlays fully transparent (inspect raw pixel colors).
execute as @e[type=text_display,tag=meccha_overlay] run data merge entity @s {background:0}
