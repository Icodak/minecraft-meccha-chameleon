# meccha:paintbrush/test_face
# Ray vs ONE rig face plane. Faces are stored in BLOCK units relative to the
# cuboid origin (scale 1000). Same parametric solve as the eyedropper:
#   t = ((P0 - O') . N)/(D . N) ; P = O' + tD ; u,v = projections / |edge|^2

execute store result score #NX meccha.math run data get storage meccha:rt wface.n[0] 1000
execute store result score #NY meccha.math run data get storage meccha:rt wface.n[1] 1000
execute store result score #NZ meccha.math run data get storage meccha:rt wface.n[2] 1000
execute store result score #PX meccha.math run data get storage meccha:rt wface.p0[0] 1000
execute store result score #PY meccha.math run data get storage meccha:rt wface.p0[1] 1000
execute store result score #PZ meccha.math run data get storage meccha:rt wface.p0[2] 1000
execute store result score #EUX meccha.math run data get storage meccha:rt wface.eu[0] 1000
execute store result score #EUY meccha.math run data get storage meccha:rt wface.eu[1] 1000
execute store result score #EUZ meccha.math run data get storage meccha:rt wface.eu[2] 1000
execute store result score #EVX meccha.math run data get storage meccha:rt wface.ev[0] 1000
execute store result score #EVY meccha.math run data get storage meccha:rt wface.ev[1] 1000
execute store result score #EVZ meccha.math run data get storage meccha:rt wface.ev[2] 1000

# denom = D . N  (D here is the LOCAL/rotated direction from test_cuboid)
scoreboard players operation #AX meccha.math = #DLX meccha.math
scoreboard players operation #AY meccha.math = #DLY meccha.math
scoreboard players operation #AZ meccha.math = #DLZ meccha.math
scoreboard players operation #BX meccha.math = #NX meccha.math
scoreboard players operation #BY meccha.math = #NY meccha.math
scoreboard players operation #BZ meccha.math = #NZ meccha.math
function meccha:lib/math/dot3
scoreboard players operation #DENOM meccha.math = #DOT meccha.math
execute if score #DENOM meccha.math matches -9..9 run return 0

# num = (P0 - O') . N
scoreboard players operation #AX meccha.math = #PX meccha.math
scoreboard players operation #AY meccha.math = #PY meccha.math
scoreboard players operation #AZ meccha.math = #PZ meccha.math
scoreboard players operation #AX meccha.math -= #OLX meccha.math
scoreboard players operation #AY meccha.math -= #OLY meccha.math
scoreboard players operation #AZ meccha.math -= #OLZ meccha.math
scoreboard players operation #BX meccha.math = #NX meccha.math
scoreboard players operation #BY meccha.math = #NY meccha.math
scoreboard players operation #BZ meccha.math = #NZ meccha.math
function meccha:lib/math/dot3
scoreboard players operation #NUM meccha.math = #DOT meccha.math

# t = num/denom
scoreboard players operation #A meccha.math = #NUM meccha.math
scoreboard players operation #B meccha.math = #DENOM meccha.math
function meccha:lib/math/div
scoreboard players operation #T meccha.math = #R meccha.math
execute if score #T meccha.math matches ..0 run return 0
execute if score #T meccha.math >= #BEST_T meccha.math run return 0

# rel = O' + tD - P0
scoreboard players operation #A meccha.math = #T meccha.math
scoreboard players operation #B meccha.math = #DLX meccha.math
function meccha:lib/math/mul
scoreboard players operation #RELX meccha.math = #OLX meccha.math
scoreboard players operation #RELX meccha.math += #R meccha.math
scoreboard players operation #RELX meccha.math -= #PX meccha.math
scoreboard players operation #A meccha.math = #T meccha.math
scoreboard players operation #B meccha.math = #DLY meccha.math
function meccha:lib/math/mul
scoreboard players operation #RELY meccha.math = #OLY meccha.math
scoreboard players operation #RELY meccha.math += #R meccha.math
scoreboard players operation #RELY meccha.math -= #PY meccha.math
scoreboard players operation #A meccha.math = #T meccha.math
scoreboard players operation #B meccha.math = #DLZ meccha.math
function meccha:lib/math/mul
scoreboard players operation #RELZ meccha.math = #OLZ meccha.math
scoreboard players operation #RELZ meccha.math += #R meccha.math
scoreboard players operation #RELZ meccha.math -= #PZ meccha.math

# u = (rel . Eu)/(Eu . Eu)
scoreboard players operation #AX meccha.math = #RELX meccha.math
scoreboard players operation #AY meccha.math = #RELY meccha.math
scoreboard players operation #AZ meccha.math = #RELZ meccha.math
scoreboard players operation #BX meccha.math = #EUX meccha.math
scoreboard players operation #BY meccha.math = #EUY meccha.math
scoreboard players operation #BZ meccha.math = #EUZ meccha.math
function meccha:lib/math/dot3
scoreboard players operation #UNUM meccha.math = #DOT meccha.math
scoreboard players operation #AX meccha.math = #EUX meccha.math
scoreboard players operation #AY meccha.math = #EUY meccha.math
scoreboard players operation #AZ meccha.math = #EUZ meccha.math
scoreboard players operation #BX meccha.math = #EUX meccha.math
scoreboard players operation #BY meccha.math = #EUY meccha.math
scoreboard players operation #BZ meccha.math = #EUZ meccha.math
function meccha:lib/math/dot3
scoreboard players operation #A meccha.math = #UNUM meccha.math
scoreboard players operation #B meccha.math = #DOT meccha.math
function meccha:lib/math/div
scoreboard players operation #U meccha.math = #R meccha.math

# v = (rel . Ev)/(Ev . Ev)
scoreboard players operation #AX meccha.math = #RELX meccha.math
scoreboard players operation #AY meccha.math = #RELY meccha.math
scoreboard players operation #AZ meccha.math = #RELZ meccha.math
scoreboard players operation #BX meccha.math = #EVX meccha.math
scoreboard players operation #BY meccha.math = #EVY meccha.math
scoreboard players operation #BZ meccha.math = #EVZ meccha.math
function meccha:lib/math/dot3
scoreboard players operation #VNUM meccha.math = #DOT meccha.math
scoreboard players operation #AX meccha.math = #EVX meccha.math
scoreboard players operation #AY meccha.math = #EVY meccha.math
scoreboard players operation #AZ meccha.math = #EVZ meccha.math
scoreboard players operation #BX meccha.math = #EVX meccha.math
scoreboard players operation #BY meccha.math = #EVY meccha.math
scoreboard players operation #BZ meccha.math = #EVZ meccha.math
function meccha:lib/math/dot3
scoreboard players operation #A meccha.math = #VNUM meccha.math
scoreboard players operation #B meccha.math = #DOT meccha.math
function meccha:lib/math/div
scoreboard players operation #V meccha.math = #R meccha.math

execute if score #U meccha.math matches 0..1000 if score #V meccha.math matches 0..1000 run function meccha:paintbrush/record_hit
