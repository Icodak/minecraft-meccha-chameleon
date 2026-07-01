# meccha:paintbrush/record_hit
# New nearest face hit. Convert (u,v) in [0,1] to integer pixel indices using
# the face's pixel resolution, and remember which cuboid/face we struck.
scoreboard players operation #BEST_T meccha.math = #T meccha.math

execute store result score #RU meccha.math run data get storage meccha:rt wface.res[0] 1
execute store result score #RV meccha.math run data get storage meccha:rt wface.res[1] 1
# pu = floor(u * res_u) ; u is *1000 so divide back out.
scoreboard players operation #PU meccha.math = #U meccha.math
scoreboard players operation #PU meccha.math *= #RU meccha.math
scoreboard players operation #PU meccha.math /= #SCALE meccha.math
scoreboard players operation #PV meccha.math = #V meccha.math
scoreboard players operation #PV meccha.math *= #RV meccha.math
scoreboard players operation #PV meccha.math /= #SCALE meccha.math
# clamp into [0, res-1]
scoreboard players operation #RUm meccha.math = #RU meccha.math
scoreboard players remove #RUm meccha.math 1
scoreboard players operation #RVm meccha.math = #RV meccha.math
scoreboard players remove #RVm meccha.math 1
execute if score #PU meccha.math > #RUm meccha.math run scoreboard players operation #PU meccha.math = #RUm meccha.math
execute if score #PV meccha.math > #RVm meccha.math run scoreboard players operation #PV meccha.math = #RVm meccha.math
execute if score #PU meccha.math matches ..-1 run scoreboard players set #PU meccha.math 0
execute if score #PV meccha.math matches ..-1 run scoreboard players set #PV meccha.math 0

data modify storage meccha:rt brush.found set value 1b
data modify storage meccha:rt brush.cuboid set from storage meccha:rt cb_id
data modify storage meccha:rt brush.rid set from storage meccha:rt cb_rid
data modify storage meccha:rt brush.face set from storage meccha:rt wface.face
execute store result storage meccha:rt brush.u int 1 run scoreboard players get #PU meccha.math
execute store result storage meccha:rt brush.v int 1 run scoreboard players get #PV meccha.math
