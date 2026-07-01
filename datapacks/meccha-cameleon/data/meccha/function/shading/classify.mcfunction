# meccha:shading/classify
# Decide which absolute axis the world normal points along, map to the vanilla
# multiplier, and set the overlay opacity = round((1 - multiplier) * 255):
#   Top    1.0 -> alpha   0      East/West 0.6 -> alpha 102
#   N/S    0.8 -> alpha  51      Bottom    0.5 -> alpha 128
scoreboard players set #NEG meccha.tmp -1

scoreboard players operation #ABSX meccha.math = #WNX meccha.math
execute if score #ABSX meccha.math matches ..-1 run scoreboard players operation #ABSX meccha.math *= #NEG meccha.tmp
scoreboard players operation #ABSY meccha.math = #WNY meccha.math
execute if score #ABSY meccha.math matches ..-1 run scoreboard players operation #ABSY meccha.math *= #NEG meccha.tmp
scoreboard players operation #ABSZ meccha.math = #WNZ meccha.math
execute if score #ABSZ meccha.math matches ..-1 run scoreboard players operation #ABSZ meccha.math *= #NEG meccha.tmp

scoreboard players set #OPA meccha.tmp 0
# Y dominant -> top (0) or bottom (128)
execute if score #ABSY meccha.math >= #ABSX meccha.math if score #ABSY meccha.math >= #ABSZ meccha.math if score #WNY meccha.math matches 0.. run scoreboard players set #OPA meccha.tmp 0
execute if score #ABSY meccha.math >= #ABSX meccha.math if score #ABSY meccha.math >= #ABSZ meccha.math if score #WNY meccha.math matches ..-1 run scoreboard players set #OPA meccha.tmp 128
# Z dominant -> north/south (51)
execute if score #ABSZ meccha.math > #ABSX meccha.math if score #ABSZ meccha.math > #ABSY meccha.math run scoreboard players set #OPA meccha.tmp 51
# X dominant -> east/west (102)
execute if score #ABSX meccha.math > #ABSY meccha.math if score #ABSX meccha.math >= #ABSZ meccha.math run scoreboard players set #OPA meccha.tmp 102

# argb = (opacity << 24) over black; overflow wrap gives the correct signed int.
scoreboard players set #M24 meccha.tmp 16777216
scoreboard players operation #ARGB meccha.math = #OPA meccha.tmp
scoreboard players operation #ARGB meccha.math *= #M24 meccha.tmp

function meccha:shading/apply_overlay with storage meccha:rt sh
