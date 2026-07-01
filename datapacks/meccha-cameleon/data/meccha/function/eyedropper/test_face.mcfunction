# meccha:eyedropper/test_face
# PILLAR 4.1 Step 3 \u2014 ray vs ONE face plane, in BLOCK-LOCAL space.
#
#   t = ((P0 - O) . N) / (D . N)        P = O + tD
#   u = (P - P0) . Eu / |Eu|^2          v = (P - P0) . Ev / |Ev|^2
#   hit iff 0<=u<=1, 0<=v<=1, t>0, t<best
#
# Model-unit values (0..16) are read with scale 62.5 (=1000/16) to convert
# straight into block units * 1000. Unit normals read at scale 1000.

# --- load face vectors ---
execute store result score #NX meccha.math run data get storage meccha:rt face.n[0] 1000
execute store result score #NY meccha.math run data get storage meccha:rt face.n[1] 1000
execute store result score #NZ meccha.math run data get storage meccha:rt face.n[2] 1000
execute store result score #PX meccha.math run data get storage meccha:rt face.p0[0] 62.5
execute store result score #PY meccha.math run data get storage meccha:rt face.p0[1] 62.5
execute store result score #PZ meccha.math run data get storage meccha:rt face.p0[2] 62.5
execute store result score #EUX meccha.math run data get storage meccha:rt face.eu[0] 62.5
execute store result score #EUY meccha.math run data get storage meccha:rt face.eu[1] 62.5
execute store result score #EUZ meccha.math run data get storage meccha:rt face.eu[2] 62.5
execute store result score #EVX meccha.math run data get storage meccha:rt face.ev[0] 62.5
execute store result score #EVY meccha.math run data get storage meccha:rt face.ev[1] 62.5
execute store result score #EVZ meccha.math run data get storage meccha:rt face.ev[2] 62.5

# --- denom = D . N ---
scoreboard players operation #AX meccha.math = #DX meccha.math
scoreboard players operation #AY meccha.math = #DY meccha.math
scoreboard players operation #AZ meccha.math = #DZ meccha.math
scoreboard players operation #BX meccha.math = #NX meccha.math
scoreboard players operation #BY meccha.math = #NY meccha.math
scoreboard players operation #BZ meccha.math = #NZ meccha.math
function meccha:lib/math/dot3
scoreboard players operation #DENOM meccha.math = #DOT meccha.math
# Reject near-parallel rays (|denom| < 0.01).
execute if score #DENOM meccha.math matches -9..9 run return 0

# --- num = (P0 - O') . N ---
scoreboard players operation #AX meccha.math = #PX meccha.math
scoreboard players operation #AY meccha.math = #PY meccha.math
scoreboard players operation #AZ meccha.math = #PZ meccha.math
scoreboard players operation #AX meccha.math -= #OX meccha.math
scoreboard players operation #AY meccha.math -= #OY meccha.math
scoreboard players operation #AZ meccha.math -= #OZ meccha.math
scoreboard players operation #BX meccha.math = #NX meccha.math
scoreboard players operation #BY meccha.math = #NY meccha.math
scoreboard players operation #BZ meccha.math = #NZ meccha.math
function meccha:lib/math/dot3
scoreboard players operation #NUM meccha.math = #DOT meccha.math

# --- t = num / denom ---
scoreboard players operation #A meccha.math = #NUM meccha.math
scoreboard players operation #B meccha.math = #DENOM meccha.math
function meccha:lib/math/div
scoreboard players operation #T meccha.math = #R meccha.math
# Behind the eye, or farther than current best? bail.
execute if score #T meccha.math matches ..0 run return 0
execute if score #T meccha.math >= #BEST_T meccha.math run return 0

# --- P' = O' + tD ; rel = P' - P0 ---
scoreboard players operation #A meccha.math = #T meccha.math
scoreboard players operation #B meccha.math = #DX meccha.math
function meccha:lib/math/mul
scoreboard players operation #RELX meccha.math = #OX meccha.math
scoreboard players operation #RELX meccha.math += #R meccha.math
scoreboard players operation #RELX meccha.math -= #PX meccha.math
scoreboard players operation #A meccha.math = #T meccha.math
scoreboard players operation #B meccha.math = #DY meccha.math
function meccha:lib/math/mul
scoreboard players operation #RELY meccha.math = #OY meccha.math
scoreboard players operation #RELY meccha.math += #R meccha.math
scoreboard players operation #RELY meccha.math -= #PY meccha.math
scoreboard players operation #A meccha.math = #T meccha.math
scoreboard players operation #B meccha.math = #DZ meccha.math
function meccha:lib/math/mul
scoreboard players operation #RELZ meccha.math = #OZ meccha.math
scoreboard players operation #RELZ meccha.math += #R meccha.math
scoreboard players operation #RELZ meccha.math -= #PZ meccha.math

# --- u = (rel . Eu) / (Eu . Eu) ---
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

# --- v = (rel . Ev) / (Ev . Ev) ---
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

say test face
# --- bounds check (0..1 in *1000 units) ---
execute if score #U meccha.math matches 0..1000 if score #V meccha.math matches 0..1000 run function meccha:eyedropper/record_best
