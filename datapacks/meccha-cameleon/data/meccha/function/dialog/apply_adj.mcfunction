# meccha:dialog/apply_adj   (executed AS the clicking player)
# A brightness/saturation button was tapped: meccha.pick_adj in 1..4.
# Adjust the currently shown dialog color, falling back to this player's
# saved color only when no preview state is present.
execute store result score #ADJ meccha.tmp run scoreboard players get @s meccha.pick_adj
scoreboard players set @s meccha.pick_adj 0

# Load the current preview color into #RRv/#GGv/#BBv.
execute if data storage meccha:rt rgb.r if data storage meccha:rt rgb.g if data storage meccha:rt rgb.b run execute store result score #RRv meccha.math run data get storage meccha:rt rgb.r
execute if data storage meccha:rt rgb.r if data storage meccha:rt rgb.g if data storage meccha:rt rgb.b run execute store result score #GGv meccha.math run data get storage meccha:rt rgb.g
execute if data storage meccha:rt rgb.r if data storage meccha:rt rgb.g if data storage meccha:rt rgb.b run execute store result score #BBv meccha.math run data get storage meccha:rt rgb.b
execute unless data storage meccha:rt rgb.r unless data storage meccha:rt rgb.g unless data storage meccha:rt rgb.b run function meccha:lib/color/unpack

execute if score #ADJ meccha.tmp matches 1 run function meccha:dialog/adj_brighter
execute if score #ADJ meccha.tmp matches 2 run function meccha:dialog/adj_darker
execute if score #ADJ meccha.tmp matches 3 run function meccha:dialog/adj_sat_up
execute if score #ADJ meccha.tmp matches 4 run function meccha:dialog/adj_sat_down
execute if score #ADJ meccha.tmp matches 5 run tag @s add paint_with_automatic_directional_shadow
execute if score #ADJ meccha.tmp matches 6 run tag @s remove paint_with_automatic_directional_shadow

# Store the adjusted channels back to this player's color, then feedback.
execute store result storage meccha:rt rgb.r int 1 run scoreboard players get #RRv meccha.math
execute store result storage meccha:rt rgb.g int 1 run scoreboard players get #GGv meccha.math
execute store result storage meccha:rt rgb.b int 1 run scoreboard players get #BBv meccha.math
function meccha:dialog/build_hex with storage meccha:rt rgb

data modify storage meccha:player color set from storage meccha:rt sample.rgb
function meccha:lib/uuid/store_current_uuid_as_string with entity @s

function meccha:lib/color/store_player_color with storage meccha:player

function meccha:dialog/open_macro with storage meccha:rt sample