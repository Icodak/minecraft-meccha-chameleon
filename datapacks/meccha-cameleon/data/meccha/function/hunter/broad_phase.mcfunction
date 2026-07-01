# meccha:hunter/broad_phase   (executed AS a hider root marker, at @s)
# PILLAR 7.2 - AABB Slab Method against this hider's root Fat BBox. Discard
# misses immediately; only on a hit do we descend into the OBB narrow phase.

# Fat BBox centre = rootPos + data.fat.c ; half = data.fat.h
execute store result score #CX meccha.math run data get entity @s Pos[0] 1000
execute store result score #CY meccha.math run data get entity @s Pos[1] 1000
execute store result score #CZ meccha.math run data get entity @s Pos[2] 1000
execute store result score #FCX meccha.math run data get entity @s data.fat.c[0] 1000
execute store result score #FCY meccha.math run data get entity @s data.fat.c[1] 1000
execute store result score #FCZ meccha.math run data get entity @s data.fat.c[2] 1000
scoreboard players operation #CX meccha.math += #FCX meccha.math
scoreboard players operation #CY meccha.math += #FCY meccha.math
scoreboard players operation #CZ meccha.math += #FCZ meccha.math
execute store result score #HX meccha.math run data get entity @s data.fat.h[0] 1000
execute store result score #HY meccha.math run data get entity @s data.fat.h[1] 1000
execute store result score #HZ meccha.math run data get entity @s data.fat.h[2] 1000

# O' = O - center ; D' = D  (world dir)
scoreboard players operation #OLX meccha.math = #OX meccha.math
scoreboard players operation #OLY meccha.math = #OY meccha.math
scoreboard players operation #OLZ meccha.math = #OZ meccha.math
scoreboard players operation #OLX meccha.math -= #CX meccha.math
scoreboard players operation #OLY meccha.math -= #CY meccha.math
scoreboard players operation #OLZ meccha.math -= #CZ meccha.math
scoreboard players operation #DLX meccha.math = #DX meccha.math
scoreboard players operation #DLY meccha.math = #DY meccha.math
scoreboard players operation #DLZ meccha.math = #DZ meccha.math

function meccha:lib/math/aabb_slab
# Hit -> narrow phase over this hider's limb cuboids.
execute if score #SLAB_OK meccha.tmp matches 1 run function meccha:hunter/narrow_phase
