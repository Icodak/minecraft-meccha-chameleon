# meccha:lib/color/pack   (executed AS a player)
# Pack #RRv/#GGv/#BBv (0..255) into this player's meccha.color = 0xRRGGBB.
scoreboard players set #C65536 meccha.tmp 65536
scoreboard players set #C256 meccha.tmp 256
scoreboard players operation #PK meccha.math = #RRv meccha.math
scoreboard players operation #PK meccha.math *= #C65536 meccha.tmp
scoreboard players operation #TG meccha.math = #GGv meccha.math
scoreboard players operation #TG meccha.math *= #C256 meccha.tmp
scoreboard players operation #PK meccha.math += #TG meccha.math
scoreboard players operation #PK meccha.math += #BBv meccha.math
scoreboard players operation @s meccha.color = #PK meccha.math
