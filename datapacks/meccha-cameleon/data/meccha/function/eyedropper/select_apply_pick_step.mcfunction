# meccha:eyedropper/select_apply_pick_step
# Walk the weighted list subtracting each weight from the running remainder
# (#HASH in [0, TOTAL-1]); the entry that drops it below zero is chosen. This
# guarantees exactly one model is selected for any in-range hash.
data modify storage meccha:rt pick.entry set from storage meccha:rt pick.apply[0]
data remove storage meccha:rt pick.apply[0]
execute store result score #W meccha.tmp run data get storage meccha:rt pick.entry.weight 1
execute if score #HASH meccha.tmp < #W meccha.tmp run data modify storage meccha:rt sel.model set from storage meccha:rt pick.entry.model
execute if score #HASH meccha.tmp < #W meccha.tmp run return 0
scoreboard players operation #HASH meccha.tmp -= #W meccha.tmp
function meccha:eyedropper/select_apply_pick
