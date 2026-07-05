# meccha:shading/refresh_cuboid   (executed AS a pose_dirty cuboid marker) shading entrypoint
# PILLAR 6 - recompute each face's world normal after a pose change and set
# its overlay text_opacity to reproduce vanilla directional shading.
data modify storage meccha:rt sh set value {}
data modify storage meccha:rt sh.id set from entity @s data.cuboid

# Pose angles -> 0..359 integer degrees (floored modulo handles negatives).
scoreboard players set #C360 meccha.tmp 360
execute store result score #DYAW meccha.tmp run data get entity @s Rotation[0] 1
execute store result score #DPITCH meccha.tmp run data get entity @s Rotation[1] 1
scoreboard players operation #DYAW meccha.tmp %= #C360 meccha.tmp
scoreboard players operation #DPITCH meccha.tmp %= #C360 meccha.tmp
execute store result storage meccha:rt sh.yaw int 1 run scoreboard players get #DYAW meccha.tmp
execute store result storage meccha:rt sh.pitch int 1 run scoreboard players get #DPITCH meccha.tmp
function meccha:shading/load_trig with storage meccha:rt sh

# Shade all six faces (local normals are constant per face dir).
function meccha:shading/shade_north
function meccha:shading/shade_south
function meccha:shading/shade_east
function meccha:shading/shade_west
function meccha:shading/shade_top
function meccha:shading/shade_bottom

tag @s remove pose_dirty