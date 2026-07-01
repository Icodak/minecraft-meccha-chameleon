# meccha:dialog/apply_rgb (executed AS the clicking player)
# A swatch was tapped: meccha.pick_rgb = packed 0xRRGGBB + 1.
execute store result score #P meccha.tmp run scoreboard players get @s meccha.pick_rgb
scoreboard players set @s meccha.pick_rgb 0
scoreboard players remove #P meccha.tmp 1

# Per-player brush colour (packed 0xRRGGBB) - multiplayer-safe.
scoreboard players operation @s meccha.color = #P meccha.tmp

# Decode for the hex/storage feedback.
scoreboard players set #C256 meccha.tmp 256
scoreboard players set #C65536 meccha.tmp 65536
scoreboard players operation #R meccha.tmp = #P meccha.tmp
scoreboard players operation #R meccha.tmp /= #C65536 meccha.tmp
scoreboard players operation #G meccha.tmp = #P meccha.tmp
scoreboard players operation #G meccha.tmp /= #C256 meccha.tmp
scoreboard players operation #G meccha.tmp %= #C256 meccha.tmp
scoreboard players operation #B meccha.tmp = #P meccha.tmp
scoreboard players operation #B meccha.tmp %= #C256 meccha.tmp

# Write to unified final RGB storage
execute store result storage meccha:rt rgb.r int 1 run scoreboard players get #R meccha.tmp
execute store result storage meccha:rt rgb.g int 1 run scoreboard players get #G meccha.tmp
execute store result storage meccha:rt rgb.b int 1 run scoreboard players get #B meccha.tmp

# Direct hex string reconstruction (or rely on build_hex to populate sample.rgb)
function meccha:dialog/build_hex with storage meccha:rt rgb