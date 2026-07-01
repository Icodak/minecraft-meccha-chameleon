# meccha:rig/debug_cuboid   (executed AS a cuboid marker)
# Report one cuboid's id, world origin and rotation.
data modify storage meccha:rt dbg.c set value {}
data modify storage meccha:rt dbg.c.id set from entity @s data.cuboid
data modify storage meccha:rt dbg.c.rid set from entity @s data.rid
execute store result storage meccha:rt dbg.c.x double 0.01 run data get entity @s Pos[0] 100
execute store result storage meccha:rt dbg.c.y double 0.01 run data get entity @s Pos[1] 100
execute store result storage meccha:rt dbg.c.z double 0.01 run data get entity @s Pos[2] 100
execute store result storage meccha:rt dbg.c.yaw double 0.01 run data get entity @s Rotation[0] 100
execute store result storage meccha:rt dbg.c.pitch double 0.01 run data get entity @s Rotation[1] 100
function meccha:rig/debug_cuboid_line with storage meccha:rt dbg.c
