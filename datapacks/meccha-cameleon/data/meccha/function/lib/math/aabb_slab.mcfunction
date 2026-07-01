# meccha:lib/math/aabb_slab
# AABB slab test, box centred at origin (caller pre-subtracts the centre).
# IN : #OLX/#OLY/#OLZ (origin-center), #DLX/#DLY/#DLZ (dir), #HX/#HY/#HZ (half)
# OUT: #SLAB_OK (1 hit / 0 miss), #TMIN (entry t, *1000)
scoreboard players set #SLAB_OK meccha.tmp 1
scoreboard players set #TMIN meccha.math -2000000000
scoreboard players set #TMAX meccha.math 2000000000

scoreboard players operation #SO meccha.math = #OLX meccha.math
scoreboard players operation #SD meccha.math = #DLX meccha.math
scoreboard players operation #SH meccha.math = #HX meccha.math
function meccha:lib/math/slab_axis
scoreboard players operation #SO meccha.math = #OLY meccha.math
scoreboard players operation #SD meccha.math = #DLY meccha.math
scoreboard players operation #SH meccha.math = #HY meccha.math
function meccha:lib/math/slab_axis
scoreboard players operation #SO meccha.math = #OLZ meccha.math
scoreboard players operation #SD meccha.math = #DLZ meccha.math
scoreboard players operation #SH meccha.math = #HZ meccha.math
function meccha:lib/math/slab_axis

# Hit iff the interval is non-empty and ends in front of the eye.
execute if score #TMIN meccha.math > #TMAX meccha.math run scoreboard players set #SLAB_OK meccha.tmp 0
execute if score #TMAX meccha.math matches ..0 run scoreboard players set #SLAB_OK meccha.tmp 0
