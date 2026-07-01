# meccha:dialog/apply_adj   (executed AS the clicking player)
# A brightness/saturation button was tapped: meccha.pick_adj in 1..4.
# Adjust THIS player's own colour (meccha.color) in RGB space.
execute store result score #ADJ meccha.tmp run scoreboard players get @s meccha.pick_adj
scoreboard players set @s meccha.pick_adj 0

# Load this player's colour into #RRv/#GGv/#BBv.
function meccha:lib/color/unpack

execute if score #ADJ meccha.tmp matches 1 run function meccha:dialog/adj_brighter
execute if score #ADJ meccha.tmp matches 2 run function meccha:dialog/adj_darker
execute if score #ADJ meccha.tmp matches 3 run function meccha:dialog/adj_sat_up
execute if score #ADJ meccha.tmp matches 4 run function meccha:dialog/adj_sat_down

# Store the adjusted channels back to this player's colour, then feedback.
function meccha:lib/color/pack
execute store result storage meccha:rt rgb.r int 1 run scoreboard players get #RRv meccha.math
execute store result storage meccha:rt rgb.g int 1 run scoreboard players get #GGv meccha.math
execute store result storage meccha:rt rgb.b int 1 run scoreboard players get #BBv meccha.math
function meccha:dialog/build_hex with storage meccha:rt rgb
