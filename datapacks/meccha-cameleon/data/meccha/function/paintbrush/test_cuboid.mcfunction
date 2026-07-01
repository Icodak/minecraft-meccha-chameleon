# meccha:paintbrush/test_cuboid   (executed `as` a cuboid marker)
# Load this cuboid's world-space face list (rebuilt on every pose update, see
# Pillar 5/6) and ray-test each face. The marker's own position is the
# cuboid origin, but faces are already stored absolute, so we test directly.
data modify storage meccha:rt cb set from entity @s data
data modify storage meccha:rt cb_id set from entity @s data.cuboid
data modify storage meccha:rt cb_rid set from entity @s data.rid
data modify storage meccha:rt wfaces set from entity @s data.wfaces

# Local ray origin O' = O - cuboidOrigin (keeps fixed-point in range; faces
# are stored relative to this marker's position).
execute store result score #BX meccha.math run data get entity @s Pos[0] 1000
execute store result score #BY meccha.math run data get entity @s Pos[1] 1000
execute store result score #BZ meccha.math run data get entity @s Pos[2] 1000
scoreboard players operation #OLX meccha.math = #OX meccha.math
scoreboard players operation #OLY meccha.math = #OY meccha.math
scoreboard players operation #OLZ meccha.math = #OZ meccha.math
scoreboard players operation #OLX meccha.math -= #BX meccha.math
scoreboard players operation #OLY meccha.math -= #BY meccha.math
scoreboard players operation #OLZ meccha.math -= #BZ meccha.math

function meccha:paintbrush/faces_loop
