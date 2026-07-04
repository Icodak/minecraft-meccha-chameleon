# meccha:paintbrush/paint_cross   (macro: $(rid) $(cuboid) $(face) $(u) $(v) $(color))
# Brush type "cross" — paint the target pixel plus its four orthogonal
# UV neighbours (up/down/left/right). Missing edge neighbours simply
# don't match any entity, so out-of-bounds cells are silently skipped.
# Requires objective: scoreboard objectives add meccha.math dummy

# centre pixel
$execute as @e[type=text_display,tag=meccha_pixel,tag=r$(rid),tag=cb_$(cuboid),tag=face_$(face),tag=u_$(u),tag=v_$(v),limit=1] run function meccha:paintbrush/apply_color {color:"$(color)"}

# load u/v into scoreboard for arithmetic
$scoreboard players set #cross.u meccha.math $(u)
$scoreboard players set #cross.v meccha.math $(v)

scoreboard players operation #cross.u+ meccha.math = #cross.u meccha.math
scoreboard players add #cross.u+ meccha.math 1
scoreboard players operation #cross.u- meccha.math = #cross.u meccha.math
scoreboard players remove #cross.u- meccha.math 1
scoreboard players operation #cross.v+ meccha.math = #cross.v meccha.math
scoreboard players add #cross.v+ meccha.math 1
scoreboard players operation #cross.v- meccha.math = #cross.v meccha.math
scoreboard players remove #cross.v- meccha.math 1

# scratch copy of the brush for neighbour lookups (keeps rid/cuboid/face/color intact)
data modify storage meccha:rt cross set from storage meccha:rt brush

# right (u+1, v)
execute store result storage meccha:rt cross.u int 1 run scoreboard players get #cross.u+ meccha.math
function meccha:paintbrush/paint_pixel with storage meccha:rt cross

# left (u-1, v)
execute store result storage meccha:rt cross.u int 1 run scoreboard players get #cross.u- meccha.math
function meccha:paintbrush/paint_pixel with storage meccha:rt cross

# restore u, then up (v+1)
data modify storage meccha:rt cross.u set from storage meccha:rt brush.u
execute store result storage meccha:rt cross.v int 1 run scoreboard players get #cross.v+ meccha.math
function meccha:paintbrush/paint_pixel with storage meccha:rt cross

# down (v-1)
execute store result storage meccha:rt cross.v int 1 run scoreboard players get #cross.v- meccha.math
function meccha:paintbrush/paint_pixel with storage meccha:rt cross