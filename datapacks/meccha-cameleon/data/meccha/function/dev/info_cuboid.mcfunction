# meccha:dev/info_cuboid   (macro: $(rid) $(cuboid))
# Dump a single cuboid's full marker data + live world pose.
$tellraw @s [{"text":"── r$(rid) $(cuboid) ──","color":"gold","bold":true}]
$execute as @e[tag=cb_$(cuboid),tag=r$(rid),type=marker,limit=1] run function meccha:dev/info_cuboid_body
