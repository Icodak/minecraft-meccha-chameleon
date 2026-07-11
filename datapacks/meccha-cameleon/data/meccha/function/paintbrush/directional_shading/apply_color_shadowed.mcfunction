# meccha:paintbrush/directional_shading/apply_color_shadowed
# MACRO INPUTS:
#   $(color) - Hex string (e.g., "#RRGGBBAA")

# 1. Run the normal calculation (Assumes your entry function is named this)
function meccha:paintbrush/directional_shading/compute_world_normal

# 2. Store the passed color into the hex parser storage
$data modify storage meccha:rt col.hex set value "$(color)"

# 3. Parse the color into #RRv, #GGv, #BBv, #AAv
function meccha:lib/color/hex_to_argb

# 4. Load vector components directly from the normal calculation's meccha.math scores
scoreboard players operation #dx meccha.math = $marker_x meccha.math
scoreboard players operation #dy meccha.math = $marker_y meccha.math
scoreboard players operation #dz meccha.math = $marker_z meccha.math

# 5. Get absolute values (Weights)
# X Weight
scoreboard players operation #wx meccha.math = #dx meccha.math
execute if score #wx meccha.math matches ..-1 run scoreboard players operation #wx meccha.math *= #NEGATIVE_ONE meccha.math

# Z Weight
scoreboard players operation #wz meccha.math = #dz meccha.math
execute if score #wz meccha.math matches ..-1 run scoreboard players operation #wz meccha.math *= #NEGATIVE_ONE meccha.math

# Y is split into positive and negative since they have different shadows
scoreboard players set #wy_pos meccha.math 0
scoreboard players set #wy_neg meccha.math 0
execute if score #dy meccha.math matches 1.. run scoreboard players operation #wy_pos meccha.math = #dy meccha.math
execute if score #dy meccha.math matches ..-1 run scoreboard players operation #wy_neg meccha.math = #dy meccha.math
execute if score #wy_neg meccha.math matches ..-1 run scoreboard players operation #wy_neg meccha.math *= #NEGATIVE_ONE meccha.math

# Calculate Total Weight (|x| + |y| + |z|)
scoreboard players operation #w_total meccha.math = #wx meccha.math
scoreboard players operation #w_total meccha.math += #wz meccha.math
scoreboard players operation #w_total meccha.math += #wy_pos meccha.math
scoreboard players operation #w_total meccha.math += #wy_neg meccha.math

# 6. Apply Shadow Multipliers
# Both X sides are 0.7 (700)
scoreboard players operation #sx meccha.math = #wx meccha.math
scoreboard players set #M700 meccha.tmp 700
scoreboard players operation #sx meccha.math *= #M700 meccha.tmp

# Both Z sides are 0.9 (900)
scoreboard players operation #sz meccha.math = #wz meccha.math
scoreboard players set #M900 meccha.tmp 900
scoreboard players operation #sz meccha.math *= #M900 meccha.tmp

# Y+ is 1.0 (1000)
scoreboard players operation #sy_pos meccha.math = #wy_pos meccha.math
scoreboard players set #M1000 meccha.tmp 1000
scoreboard players operation #sy_pos meccha.math *= #M1000 meccha.tmp

# Y- is 0.4 (400)
scoreboard players operation #sy_neg meccha.math = #wy_neg meccha.math
scoreboard players set #M400 meccha.tmp 400
scoreboard players operation #sy_neg meccha.math *= #M400 meccha.tmp

# Sum up all shadowed weights
scoreboard players operation #s_total meccha.math = #sx meccha.math
scoreboard players operation #s_total meccha.math += #sz meccha.math
scoreboard players operation #s_total meccha.math += #sy_pos meccha.math
scoreboard players operation #s_total meccha.math += #sy_neg meccha.math

# 7. Calculate Final Shadow Ratio (S)
# S = s_total / w_total. Default to 1000 if vector is 0,0,0
scoreboard players set #S meccha.math 1000
execute if score #w_total meccha.math matches 1.. run scoreboard players operation #S meccha.math = #s_total meccha.math
execute if score #w_total meccha.math matches 1.. run scoreboard players operation #S meccha.math /= #w_total meccha.math

# 8. Apply the Shadow to RGB channels
# Red
scoreboard players operation #RRv meccha.math *= #S meccha.math
scoreboard players operation #RRv meccha.math /= #SCALE meccha.math
# Green
scoreboard players operation #GGv meccha.math *= #S meccha.math
scoreboard players operation #GGv meccha.math /= #SCALE meccha.math
# Blue
scoreboard players operation #BBv meccha.math *= #S meccha.math
scoreboard players operation #BBv meccha.math /= #SCALE meccha.math

execute store result storage meccha:rt rgb.r int 1 run scoreboard players get #RRv meccha.math
execute store result storage meccha:rt rgb.g int 1 run scoreboard players get #GGv meccha.math
execute store result storage meccha:rt rgb.b int 1 run scoreboard players get #BBv meccha.math
function meccha:color_picker/build_hex with storage meccha:rt rgb

# 9. Safely apply the constructed hex color to the entity

data modify entity @s text.color set from storage meccha:rt sample.rgb