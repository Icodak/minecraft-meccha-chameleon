# meccha:lib/math/mul
# Fixed-point multiply: #R = (#A * #B) / SCALE   (all in meccha.math, *1000)
# Caller sets #A and #B. Result in #R.
scoreboard players operation #R meccha.math = #A meccha.math
scoreboard players operation #R meccha.math *= #B meccha.math
scoreboard players operation #R meccha.math /= #SCALE meccha.math
