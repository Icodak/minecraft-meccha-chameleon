# meccha:lib/color/unpack   (executed AS a player)
# Read this player's packed 0xRRGGBB colour (objective meccha.color) into
# channels + an opaque ARGB int ready for a text_display background.
# OUT: #RRv/#GGv/#BBv (0..255), #ARGB (signed opaque ARGB)  \u2014 all meccha.math
scoreboard players set #C65536 meccha.tmp 65536
scoreboard players set #C256 meccha.tmp 256
execute store result score #CC meccha.math run scoreboard players get @s meccha.color
scoreboard players operation #RRv meccha.math = #CC meccha.math
scoreboard players operation #RRv meccha.math /= #C65536 meccha.tmp
scoreboard players operation #GGv meccha.math = #CC meccha.math
scoreboard players operation #GGv meccha.math /= #C256 meccha.tmp
scoreboard players operation #GGv meccha.math %= #C256 meccha.tmp
scoreboard players operation #BBv meccha.math = #CC meccha.math
scoreboard players operation #BBv meccha.math %= #C256 meccha.tmp
# opaque ARGB = packed | 0xFF000000  ==  packed - 16777216  (2's complement)
scoreboard players operation #ARGB meccha.math = #CC meccha.math
scoreboard players remove #ARGB meccha.math 16777216
