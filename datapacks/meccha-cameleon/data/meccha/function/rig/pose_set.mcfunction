# meccha:rig/pose_set   (macro: $(rid), $(pose))
# Set a specific rig's pose and apply it. Records data.pose on the root so
# follow / reapply can re-run the current pose.
$data modify entity @e[tag=meccha_rig_root,tag=r$(rid),limit=1] data.pose set value "$(pose)"
$execute as @e[tag=meccha_rig_root,tag=r$(rid),limit=1] at @s run function meccha:rig/apply_current
