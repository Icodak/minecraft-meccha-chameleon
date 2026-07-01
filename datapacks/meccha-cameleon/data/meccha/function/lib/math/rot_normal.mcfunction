# meccha:lib/math/rot_normal
# Rotate a LOCAL normal (#NLX/#NLY/#NLZ, *1000) into world space by the cuboid
# pose: first pitch about X, then yaw about Y. Trig comes from scores
# #SINP/#COSP/#SINY/#COSY (*1000, loaded from the trig table).
# OUT: #WNX/#WNY/#WNZ (*1000).

# n1 = Rx(pitch) * n_local
scoreboard players operation #N1X meccha.math = #NLX meccha.math
# n1y = nly*cosP - nlz*sinP
scoreboard players operation #T1 meccha.math = #NLY meccha.math
scoreboard players operation #T1 meccha.math *= #COSP meccha.math
scoreboard players operation #T1 meccha.math /= #SCALE meccha.math
scoreboard players operation #T2 meccha.math = #NLZ meccha.math
scoreboard players operation #T2 meccha.math *= #SINP meccha.math
scoreboard players operation #T2 meccha.math /= #SCALE meccha.math
scoreboard players operation #N1Y meccha.math = #T1 meccha.math
scoreboard players operation #N1Y meccha.math -= #T2 meccha.math
# n1z = nly*sinP + nlz*cosP
scoreboard players operation #T1 meccha.math = #NLY meccha.math
scoreboard players operation #T1 meccha.math *= #SINP meccha.math
scoreboard players operation #T1 meccha.math /= #SCALE meccha.math
scoreboard players operation #T2 meccha.math = #NLZ meccha.math
scoreboard players operation #T2 meccha.math *= #COSP meccha.math
scoreboard players operation #T2 meccha.math /= #SCALE meccha.math
scoreboard players operation #N1Z meccha.math = #T1 meccha.math
scoreboard players operation #N1Z meccha.math += #T2 meccha.math

# n_world = Ry(yaw) * n1
# wnx = n1x*cosY + n1z*sinY
scoreboard players operation #T1 meccha.math = #N1X meccha.math
scoreboard players operation #T1 meccha.math *= #COSY meccha.math
scoreboard players operation #T1 meccha.math /= #SCALE meccha.math
scoreboard players operation #T2 meccha.math = #N1Z meccha.math
scoreboard players operation #T2 meccha.math *= #SINY meccha.math
scoreboard players operation #T2 meccha.math /= #SCALE meccha.math
scoreboard players operation #WNX meccha.math = #T1 meccha.math
scoreboard players operation #WNX meccha.math += #T2 meccha.math
# wny = n1y
scoreboard players operation #WNY meccha.math = #N1Y meccha.math
# wnz = -n1x*sinY + n1z*cosY
scoreboard players operation #T1 meccha.math = #N1X meccha.math
scoreboard players operation #T1 meccha.math *= #SINY meccha.math
scoreboard players operation #T1 meccha.math /= #SCALE meccha.math
scoreboard players operation #T2 meccha.math = #N1Z meccha.math
scoreboard players operation #T2 meccha.math *= #COSY meccha.math
scoreboard players operation #T2 meccha.math /= #SCALE meccha.math
scoreboard players operation #WNZ meccha.math = #T2 meccha.math
scoreboard players operation #WNZ meccha.math -= #T1 meccha.math
