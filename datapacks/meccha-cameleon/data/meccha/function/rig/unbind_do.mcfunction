# meccha:rig/unbind_do   (executed AS the owning player)
data modify storage meccha:rt del set value {rid:0}
execute store result storage meccha:rt del.rid int 1 run scoreboard players get @s meccha.rig
function meccha:rig/despawn with storage meccha:rt del
