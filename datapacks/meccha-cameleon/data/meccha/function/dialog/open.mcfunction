# meccha:dialog/open   (op helper)
# Open the color picker for the executing player. Non-ops can also open it from
# the pause menu / Quick Actions key (see the dialog tags). Enable the triggers
# so the first click registers immediately.
scoreboard players enable @s meccha.pick_rgb
scoreboard players enable @s meccha.pick_adj

# Keep the dialog preview and the player's active color in sync so
# brightness/saturation edits the same color that is currently shown.
execute if data storage meccha:rt sample.rgb run data modify storage meccha:rt col.rr set string storage meccha:rt sample.rgb 1 3
execute if data storage meccha:rt sample.rgb run data modify storage meccha:rt col.gg set string storage meccha:rt sample.rgb 3 5
execute if data storage meccha:rt sample.rgb run data modify storage meccha:rt col.bb set string storage meccha:rt sample.rgb 5 7
execute if data storage meccha:rt sample.rgb run data modify storage meccha:rt col.aa set value "FF"
execute if data storage meccha:rt sample.rgb run function meccha:lib/color/lookup_argb with storage meccha:rt col
execute if data storage meccha:rt sample.rgb run function meccha:lib/color/pack
execute if data storage meccha:rt sample.rgb run execute store result storage meccha:rt rgb.r int 1 run scoreboard players get #RRv meccha.math
execute if data storage meccha:rt sample.rgb run execute store result storage meccha:rt rgb.g int 1 run scoreboard players get #GGv meccha.math
execute if data storage meccha:rt sample.rgb run execute store result storage meccha:rt rgb.b int 1 run scoreboard players get #BBv meccha.math

function meccha:dialog/open_macro with storage meccha:rt sample
