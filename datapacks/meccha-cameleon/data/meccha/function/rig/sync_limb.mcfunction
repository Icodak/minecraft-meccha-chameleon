# meccha:rig/sync_limb   (executed AS a limb cuboid marker)
# Append this limb's OBB descriptor to its rig's BVH schema (keyed by data.rid).
data modify storage meccha:rt limb set value {origin:[0.0d,0.0d,0.0d],rot:[0,0]}
data modify storage meccha:rt limb.rid set from entity @s data.rid
data modify storage meccha:rt limb.id set from entity @s data.cuboid
data modify storage meccha:rt limb.half set from entity @s data.half
data modify storage meccha:rt limb.hp set from entity @s data.hp
execute store result storage meccha:rt limb.origin[0] double 0.01 run data get entity @s Pos[0] 100
execute store result storage meccha:rt limb.origin[1] double 0.01 run data get entity @s Pos[1] 100
execute store result storage meccha:rt limb.origin[2] double 0.01 run data get entity @s Pos[2] 100
execute store result storage meccha:rt limb.rot[0] int 1 run data get entity @s Rotation[0] 1
execute store result storage meccha:rt limb.rot[1] int 1 run data get entity @s Rotation[1] 1
function meccha:rig/sync_limb_append with storage meccha:rt limb
