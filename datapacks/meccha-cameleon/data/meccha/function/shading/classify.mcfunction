# meccha:shading/classify
# Decide which absolute axis the world normal points along and map it to the
# vanilla directional-light opacity. text_opacity is a signed byte where
# 0-127 map straight through (only values >=128 would need the -256 wrap
# mentioned in the wiki), and our four targets all fit that range directly --
# no ARGB packing, no <<24, no compositing "over black". The overlay's
# `text.color` stays a plain, constant RGB (black); only text_opacity varies.
#   Top     -> opacity   0      East/West -> opacity  26
#   N/S     -> opacity  45      Bottom    -> opacity  100
scoreboard players set #NEG meccha.tmp -1

scoreboard players operation #ABSX meccha.math = #WNX meccha.math
execute if score #ABSX meccha.math matches ..-1 run scoreboard players operation #ABSX meccha.math *= #NEG meccha.tmp
scoreboard players operation #ABSY meccha.math = #WNY meccha.math
execute if score #ABSY meccha.math matches ..-1 run scoreboard players operation #ABSY meccha.math *= #NEG meccha.tmp
scoreboard players operation #ABSZ meccha.math = #WNZ meccha.math
execute if score #ABSZ meccha.math matches ..-1 run scoreboard players operation #ABSZ meccha.math *= #NEG meccha.tmp

scoreboard players set #OPA meccha.tmp 0
# Y dominant -> top (0) or bottom (100)
execute if score #ABSY meccha.math >= #ABSX meccha.math if score #ABSY meccha.math >= #ABSZ meccha.math if score #WNY meccha.math matches 0.. run scoreboard players set #OPA meccha.tmp 0
execute if score #ABSY meccha.math >= #ABSX meccha.math if score #ABSY meccha.math >= #ABSZ meccha.math if score #WNY meccha.math matches ..-1 run scoreboard players set #OPA meccha.tmp 100
# Z dominant -> north/south (45)
execute if score #ABSZ meccha.math > #ABSX meccha.math if score #ABSZ meccha.math > #ABSY meccha.math run scoreboard players set #OPA meccha.tmp 45
# X dominant -> east/west (26)
execute if score #ABSX meccha.math > #ABSY meccha.math if score #ABSX meccha.math >= #ABSZ meccha.math run scoreboard players set #OPA meccha.tmp 26

# Hand the resolved opacity to apply_overlay via storage; no color math needed
# since the RGB stays fixed black and only this alpha value changes.
execute store result storage meccha:rt sh.opacity int 1 run scoreboard players get #OPA meccha.tmp

function meccha:shading/apply_overlay with storage meccha:rt sh