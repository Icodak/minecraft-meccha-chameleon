# meccha:eyedropper/select_apply_pick_step
data modify storage meccha:rt pick.entry set from storage meccha:rt pick.apply[0]
data remove storage meccha:rt pick.apply[0]
execute store result score #W meccha.tmp run data get storage meccha:rt pick.entry.weight 1
scoreboard players operation #CMP meccha.tmp = #HASH meccha.tmp
scoreboard players operation #CMP meccha.tmp -= #W meccha.tmp
execute if score #CMP meccha.tmp matches ..-1 run data modify storage meccha:rt sample.model set from storage meccha:rt pick.entry.model
execute if score #CMP meccha.tmp matches ..-1 run return 0
function meccha:eyedropper/select_apply_pick
