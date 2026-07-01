# meccha:rig/follow_do   (macro: $(rid) \u2014 executed at the owning player)
# Snap the rig root to the player, then re-apply the current pose so cuboids
# track the root. (Only followed rigs pay this cost.)
$tp @e[tag=meccha_rig_root,tag=r$(rid),limit=1] ~ ~ ~
$execute as @e[tag=meccha_rig_root,tag=r$(rid),limit=1] at @s run function meccha:rig/apply_current
