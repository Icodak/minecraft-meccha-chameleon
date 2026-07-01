# meccha:lib/math/div
# Fixed-point divide: #R = (#A * SCALE) / #B   (meccha.math, *1000)
# Guard against divide-by-zero (parallel ray vs plane => no hit).
scoreboard players set #DIV_OK meccha.tmp 1
execute if score #B meccha.math matches 0 run scoreboard players set #DIV_OK meccha.tmp 0
execute if score #DIV_OK meccha.tmp matches 1 run scoreboard players operation #R meccha.math = #A meccha.math
execute if score #DIV_OK meccha.tmp matches 1 run scoreboard players operation #R meccha.math *= #SCALE meccha.math
execute if score #DIV_OK meccha.tmp matches 1 run scoreboard players operation #R meccha.math /= #B meccha.math
