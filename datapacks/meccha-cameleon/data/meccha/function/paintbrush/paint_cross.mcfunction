# meccha:paintbrush/paint_cross   (macro: $(rid) $(cuboid) $(face) $(u) $(v) $(color))
# Brush type "cross" — paints the target pixel plus its four orthogonal
# neighbours, wrapping across cuboid edges onto the adjacent face when a
# neighbour falls outside the current face's UV bounds. Requires
# objective meccha.math (dummy).

$say tag=face_$(face),tag=u_$(u),tag=v_$(v)
# centre pixel
$execute as @e[type=text_display,tag=meccha_pixel,tag=r$(rid),tag=cb_$(cuboid),tag=face_$(face),tag=u_$(u),tag=v_$(v),limit=1] run function meccha:paintbrush/apply_color {color:"$(color)"}

$data modify storage meccha:rt cross set value {rid:"$(rid)",cuboid:"$(cuboid)",color:"$(color)",srcface:"$(face)",u0:$(u),v0:$(v)}

# source bounds
data modify storage meccha:rt cross.face set from storage meccha:rt cross.srcface
function meccha:lib/cuboid/get_face_bounds with storage meccha:rt cross
scoreboard players operation #src.umax meccha.math = #face.umax meccha.math
scoreboard players operation #src.vmax meccha.math = #face.vmax meccha.math

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

# ---- right (u+1) ----
data modify storage meccha:rt cross.face set from storage meccha:rt cross.srcface
data modify storage meccha:rt cross.u set from storage meccha:rt cross.u0
data modify storage meccha:rt cross.v set from storage meccha:rt cross.v0
execute if score #cross.u+ meccha.math < #src.umax meccha.math run function meccha:paintbrush/paint_cross_dir {axis:"u",score:"#cross.u+"}
$execute if score #cross.u+ meccha.math >= #src.umax meccha.math run function meccha:lib/uv/wrap/$(face)/uplus with storage meccha:rt cross

$say $(face) 
tellraw @a [{text:"#cross.u+"},{"score":{"name":"#cross.u+","objective":"meccha.math"}},{text:"umax"},{"score":{"name":"#src.umax","objective":"meccha.math"}}] 

# ---- left (u-1) ----
data modify storage meccha:rt cross.face set from storage meccha:rt cross.srcface
data modify storage meccha:rt cross.u set from storage meccha:rt cross.u0
data modify storage meccha:rt cross.v set from storage meccha:rt cross.v0
execute if score #cross.u- meccha.math matches 0.. run function meccha:paintbrush/paint_cross_dir {axis:"u",score:"#cross.u-"}
$execute if score #cross.u- meccha.math < #ZERO meccha.math run function meccha:lib/uv/wrap/$(face)/uminus with storage meccha:rt cross

# ---- down (v+1, texture-space) ----
data modify storage meccha:rt cross.face set from storage meccha:rt cross.srcface
data modify storage meccha:rt cross.u set from storage meccha:rt cross.u0
data modify storage meccha:rt cross.v set from storage meccha:rt cross.v0
execute if score #cross.v+ meccha.math < #src.vmax meccha.math run function meccha:paintbrush/paint_cross_dir {axis:"v",score:"#cross.v+"}
$execute if score #cross.v+ meccha.math >= #src.vmax meccha.math run function meccha:lib/uv/wrap/$(face)/vplus with storage meccha:rt cross

tellraw @a [{text:"#cross.v+"},{"score":{"name":"#cross.v+","objective":"meccha.math"}},{text:"vmax"},{"score":{"name":"#src.vmax","objective":"meccha.math"}}] 

# ---- up (v-1, texture-space) ----
data modify storage meccha:rt cross.face set from storage meccha:rt cross.srcface
data modify storage meccha:rt cross.u set from storage meccha:rt cross.u0
data modify storage meccha:rt cross.v set from storage meccha:rt cross.v0
execute if score #cross.v- meccha.math matches 0.. run function meccha:paintbrush/paint_cross_dir {axis:"v",score:"#cross.v-"}
$execute if score #cross.v- meccha.math < #ZERO meccha.math run function meccha:lib/uv/wrap/$(face)/vminus with storage meccha:rt cross

tellraw @a [{text:"#cross.v-"},{"score":{"name":"#cross.v-","objective":"meccha.math"}},{text:"vmin:0"}] 