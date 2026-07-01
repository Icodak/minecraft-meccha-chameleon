# meccha:lib/math/slab_axis
# One axis of the slab method for a box centred at origin with half-extent #SH.
# IN : #SO = (origin - center) along this axis, #SD = dir along this axis,
#      #SH = half extent  (all *1000)
# IO : updates #TMIN, #TMAX (running interval) and #SLAB_OK.
scoreboard players set #NEG meccha.tmp -1

# Parallel ray (|SD| tiny): hit only if origin already within the slab.
execute if score #SD meccha.math matches -2..2 run function meccha:lib/math/slab_axis_parallel
execute if score #SD meccha.math matches -2..2 run return 0

# t_a = (-SH - SO)/SD ; t_b = (SH - SO)/SD
scoreboard players operation #A meccha.math = #SH meccha.math
scoreboard players operation #A meccha.math *= #NEG meccha.tmp
scoreboard players operation #A meccha.math -= #SO meccha.math
scoreboard players operation #B meccha.math = #SD meccha.math
function meccha:lib/math/div
scoreboard players operation #TA meccha.math = #R meccha.math
scoreboard players operation #A meccha.math = #SH meccha.math
scoreboard players operation #A meccha.math -= #SO meccha.math
scoreboard players operation #B meccha.math = #SD meccha.math
function meccha:lib/math/div
scoreboard players operation #TB meccha.math = #R meccha.math

# tnear = min(TA,TB), tfar = max(TA,TB)
scoreboard players operation #TNEAR meccha.math = #TA meccha.math
scoreboard players operation #TFAR meccha.math = #TB meccha.math
execute if score #TA meccha.math > #TB meccha.math run scoreboard players operation #TNEAR meccha.math = #TB meccha.math
execute if score #TA meccha.math > #TB meccha.math run scoreboard players operation #TFAR meccha.math = #TA meccha.math

execute if score #TNEAR meccha.math > #TMIN meccha.math run scoreboard players operation #TMIN meccha.math = #TNEAR meccha.math
execute if score #TFAR meccha.math < #TMAX meccha.math run scoreboard players operation #TMAX meccha.math = #TFAR meccha.math
