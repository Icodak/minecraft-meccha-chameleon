# meccha:shading/classify
# Decide which absolute axis the world normal points along and map it to the
# vanilla directional-light opacity, then pack it into the overlay's
# `background` field. Unlike `text.color` (plain RGB, alpha lives in the
# separate `text_opacity` byte), `background` on a text_display genuinely IS
# a packed ARGB int: (alpha << 24) | (r << 16) | (g << 8) | b. Color is
# always black here, so this collapses to alpha << 24. Scoreboard math is
# 32-bit signed and wraps, which is exactly the right behavior if alpha is
# ever raised to 128-255 (matches the ARGB int's own overflow-into-sign
# convention) -- no special-casing needed.
#   Top     -> alpha   0      East/West -> alpha  70
#   N/S     -> alpha  27      Bottom    -> alpha  120
scoreboard players set #NEG meccha.tmp -1

scoreboard players operation #ABSX meccha.math = #WNX meccha.math
execute if score #ABSX meccha.math matches ..-1 run scoreboard players operation #ABSX meccha.math *= #NEG meccha.tmp
scoreboard players operation #ABSY meccha.math = #WNY meccha.math
execute if score #ABSY meccha.math matches ..-1 run scoreboard players operation #ABSY meccha.math *= #NEG meccha.tmp
scoreboard players operation #ABSZ meccha.math = #WNZ meccha.math
execute if score #ABSZ meccha.math matches ..-1 run scoreboard players operation #ABSZ meccha.math *= #NEG meccha.tmp

scoreboard players set #OPA meccha.tmp 0
# Y dominant -> top (0) or bottom (120)
execute if score #ABSY meccha.math >= #ABSX meccha.math if score #ABSY meccha.math >= #ABSZ meccha.math if score #WNY meccha.math matches 0.. run scoreboard players set #OPA meccha.tmp 0
execute if score #ABSY meccha.math >= #ABSX meccha.math if score #ABSY meccha.math >= #ABSZ meccha.math if score #WNY meccha.math matches ..-1 run scoreboard players set #OPA meccha.tmp 120
# Z dominant -> north/south (27)
execute if score #ABSZ meccha.math > #ABSX meccha.math if score #ABSZ meccha.math > #ABSY meccha.math run scoreboard players set #OPA meccha.tmp 27
# X dominant -> east/west (70)
execute if score #ABSX meccha.math > #ABSY meccha.math if score #ABSX meccha.math >= #ABSZ meccha.math run scoreboard players set #OPA meccha.tmp 70

# argb = alpha << 24, color = black. 32-bit signed multiply wraps correctly
# for alpha >= 128 if these values are ever raised that high.
scoreboard players set #M24 meccha.tmp 16777216
scoreboard players operation #ARGB meccha.math = #OPA meccha.tmp
scoreboard players operation #ARGB meccha.math *= #M24 meccha.tmp
execute store result storage meccha:rt sh.argb int 1 run scoreboard players get #ARGB meccha.math

function meccha:shading/apply_overlay with storage meccha:rt sh