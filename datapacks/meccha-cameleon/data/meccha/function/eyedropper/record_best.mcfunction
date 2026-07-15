# meccha:eyedropper/record_best
# This face is the current nearest candidate. Compute the texel, fetch the
# hex, and - only if the pixel is OPAQUE - commit it as the best hit.
# (Transparent texels must NOT advance best_t: the ray sees through them to
#  faces behind, exactly like the eyedropper "ignore #..00" rule.)

# uv pixel coords from affine face mapping:
#   pu = ub + U*uu + V*uv
#   pv = vb + U*vu + V*vv
execute store result score #UB meccha.math run data get storage meccha:rt face.uvm[0] 1000
execute store result score #VB meccha.math run data get storage meccha:rt face.uvm[1] 1000
execute store result score #UU meccha.math run data get storage meccha:rt face.uvm[2] 1000
execute store result score #UV meccha.math run data get storage meccha:rt face.uvm[3] 1000
execute store result score #VU meccha.math run data get storage meccha:rt face.uvm[4] 1000
execute store result score #VV meccha.math run data get storage meccha:rt face.uvm[5] 1000

scoreboard players operation #PU meccha.math = #UB meccha.math
scoreboard players operation #A meccha.math = #U meccha.math
scoreboard players operation #B meccha.math = #UU meccha.math
function meccha:lib/math/mul
scoreboard players operation #PU meccha.math += #R meccha.math
scoreboard players operation #A meccha.math = #V meccha.math
scoreboard players operation #B meccha.math = #UV meccha.math
function meccha:lib/math/mul
scoreboard players operation #PU meccha.math += #R meccha.math

scoreboard players operation #PV meccha.math = #VB meccha.math
scoreboard players operation #A meccha.math = #U meccha.math
scoreboard players operation #B meccha.math = #VU meccha.math
function meccha:lib/math/mul
scoreboard players operation #PV meccha.math += #R meccha.math
scoreboard players operation #A meccha.math = #V meccha.math
scoreboard players operation #B meccha.math = #VV meccha.math
function meccha:lib/math/mul
scoreboard players operation #PV meccha.math += #R meccha.math

# texel = floor(p/1000), clamped to a 16x16 sprite.
scoreboard players operation #TXU meccha.math = #PU meccha.math
scoreboard players operation #TXU meccha.math /= #SCALE meccha.math
scoreboard players operation #TXV meccha.math = #PV meccha.math
scoreboard players operation #TXV meccha.math /= #SCALE meccha.math
execute if score #TXU meccha.math matches ..-1 run scoreboard players set #TXU meccha.math 0
execute if score #TXU meccha.math matches 16.. run scoreboard players set #TXU meccha.math 15
execute if score #TXV meccha.math matches ..-1 run scoreboard players set #TXV meccha.math 0
execute if score #TXV meccha.math matches 16.. run scoreboard players set #TXV meccha.math 15

# index = TXV*16 + TXU
scoreboard players set #SIXTEEN meccha.tmp 16
scoreboard players operation #IDX meccha.math = #TXV meccha.math
scoreboard players operation #IDX meccha.math *= #SIXTEEN meccha.tmp
scoreboard players operation #IDX meccha.math += #TXU meccha.math
execute store result storage meccha:rt pick.index int 1 run scoreboard players get #IDX meccha.math

# resolve "#var" -> final texture key, then fetch the hex pixel.
# The final texture key is already baked onto each face (bake_faces), so the
# multi-part face union stays self-contained even when parts use different
# texture maps. Reset color first; a face with no texture ("") is skipped.
data modify storage meccha:rt pick.color set value "#00000000"
data modify storage meccha:rt pick.texkey set from storage meccha:rt face.tex

execute unless data storage meccha:rt {pick:{texkey:""}} run function meccha:eyedropper/fetch_pixel with storage meccha:rt pick
# alpha = last two hex chars of "#RRGGBBAA" (indices 7..9 via `set string`).
data modify storage meccha:rt pick.alpha set string storage meccha:rt pick.color 7 9
execute if data storage meccha:rt {pick:{alpha:"00"}} run return 0

# say color found
# OPAQUE -> commit as best hit.
scoreboard players operation #BEST_T meccha.math = #T meccha.math
data modify storage meccha:rt sample.color set from storage meccha:rt pick.color
data modify storage meccha:rt sample.tex set from storage meccha:rt pick.texkey
data modify storage meccha:rt sample.found set value 1b
