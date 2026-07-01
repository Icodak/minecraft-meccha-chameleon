# meccha:dev/glow_cuboid   (macro: $(rid) $(cuboid))
# Outline a cuboid's pixels (white glow) to locate it in-world.
$execute as @e[type=text_display,tag=meccha_pixel,tag=r$(rid),tag=cb_$(cuboid)] run data merge entity @s {Glowing:1b}
$tellraw @s [{"text":"[dev] ","color":"green"},{"text":"glowing r$(rid) $(cuboid)","color":"gray"}]
