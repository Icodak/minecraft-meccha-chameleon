# meccha:rig/move_to   (macro: $(rid) $(x) $(y) $(z) \u2014 absolute world coords)
# Force-move rig <rid>: relocate its root, then re-apply its current pose so
# every cuboid follows.
$tp @e[tag=meccha_rig_root,tag=r$(rid),limit=1] $(x) $(y) $(z)
$execute as @e[tag=meccha_rig_root,tag=r$(rid),limit=1] at @s run function meccha:rig/apply_current
