# meccha:dev/unglow
# Clear glow on all rig pixels.
execute as @e[type=text_display,tag=meccha_pixel] run data merge entity @s {Glowing:0b}
