# meccha:rig/sync_rig   (macro: $(rid))
# PILLAR 7.1 (multi-rig) - mirror rig <rid> into the per-rig BVH schema at
# storage meccha:players."r<rid>":
#   { rid, name, pose, root:[x,y,z], fat_bbox:{c,h}, limbs:[ {id,origin,rot,half,hp} ] }
$data modify storage meccha:players r$(rid) set value {rid:$(rid),name:"hider",root:[0.0d,0.0d,0.0d],limbs:[]}
$data modify storage meccha:players r$(rid).pose set from entity @e[tag=meccha_rig_root,tag=r$(rid),limit=1] data.pose
$data modify storage meccha:players r$(rid).fat_bbox set from entity @e[tag=meccha_rig_root,tag=r$(rid),limit=1] data.fat
$execute store result storage meccha:players r$(rid).root[0] double 0.01 run data get entity @e[tag=meccha_rig_root,tag=r$(rid),limit=1] Pos[0] 100
$execute store result storage meccha:players r$(rid).root[1] double 0.01 run data get entity @e[tag=meccha_rig_root,tag=r$(rid),limit=1] Pos[1] 100
$execute store result storage meccha:players r$(rid).root[2] double 0.01 run data get entity @e[tag=meccha_rig_root,tag=r$(rid),limit=1] Pos[2] 100
$execute as @e[tag=meccha_cuboid,tag=r$(rid)] run function meccha:rig/sync_limb
