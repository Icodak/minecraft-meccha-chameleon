# meccha:rig/debug_root   (executed AS a rig root)
data modify storage meccha:rt dbg set value {rid:0,pose:""}
data modify storage meccha:rt dbg.rid set from entity @s data.rid
data modify storage meccha:rt dbg.pose set from entity @s data.pose
execute store result storage meccha:rt dbg.x double 0.01 run data get entity @s Pos[0] 100
execute store result storage meccha:rt dbg.y double 0.01 run data get entity @s Pos[1] 100
execute store result storage meccha:rt dbg.z double 0.01 run data get entity @s Pos[2] 100
function meccha:rig/debug_root_line with storage meccha:rt dbg
