# meccha:eyedropper/record_best
# This face is the current nearest candidate. Compute the texel, fetch the
# hex, and - only if the pixel is OPAQUE - commit it as the best hit.
# (Transparent texels must NOT advance best_t: the ray sees through them to
#  faces behind, exactly like the eyedropper "ignore #..00" rule.)

# uv pixel coords: pu = uv0 + U*(uv2-uv0) ; pv = uv1 + V*(uv3-uv1)
execute store result score #UV0 meccha.math run data get storage meccha:rt face.uv[0] 1000
execute store result score #UV1 meccha.math run data get storage meccha:rt face.uv[1] 1000
execute store result score #UV2 meccha.math run data get storage meccha:rt face.uv[2] 1000
execute store result score #UV3 meccha.math run data get storage meccha:rt face.uv[3] 1000
scoreboard players operation #DU meccha.math = #UV2 meccha.math
scoreboard players operation #DU meccha.math -= #UV0 meccha.math
scoreboard players operation #DV meccha.math = #UV3 meccha.math
scoreboard players operation #DV meccha.math -= #UV1 meccha.math
scoreboard players operation #A meccha.math = #U meccha.math
scoreboard players operation #B meccha.math = #DU meccha.math
function meccha:lib/math/mul
scoreboard players operation #PU meccha.math = #UV0 meccha.math
scoreboard players operation #PU meccha.math += #R meccha.math
scoreboard players operation #A meccha.math = #V meccha.math
scoreboard players operation #B meccha.math = #DV meccha.math
function meccha:lib/math/mul
scoreboard players operation #PV meccha.math = #UV1 meccha.math
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
# Reset texkey/color first so a var missing from the model's texture map can't
# leave a stale key (or raise a macro error in fetch_pixel).
data modify storage meccha:rt pick.texkey set value ""
data modify storage meccha:rt pick.color set value "#00000000"
data modify storage meccha:rt pick.var set from storage meccha:rt face.var

function meccha:eyedropper/resolve_tex with storage meccha:rt pick
# tellraw @a [{"text":"Pick: ","color":"gold"},{"nbt":"pick","storage":"meccha:rt","interpret":false,"color":"aqua"}]

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
