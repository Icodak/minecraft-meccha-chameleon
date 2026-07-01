# meccha:role/cycle_pose   (executed AS a hider holding the Pose Switcher)
# Advance the pose of THIS player's bound rig (meccha.rig): standing ->
# crawling -> curled_up -> standing.
execute unless score @s meccha.rig matches 1.. run return run title @s actionbar {"text":"No rig bound - use /function meccha:rig/spawn_for","color":"gray"}
data modify storage meccha:rt cyc set value {rid:0,cur:"",pose:"standing"}
execute store result storage meccha:rt cyc.rid int 1 run scoreboard players get @s meccha.rig
function meccha:role/cycle_pose_do with storage meccha:rt cyc
function meccha:role/pose_feedback with storage meccha:rt cyc
playsound minecraft:block.note_block.hat player @s ~ ~ ~ 1 1.2
