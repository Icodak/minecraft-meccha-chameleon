# meccha:eyedropper/select_apply_sum_step
data modify storage meccha:rt pick.entry set from storage meccha:rt pick.apply[0]
data remove storage meccha:rt pick.apply[0]
execute store result score #W meccha.tmp run data get storage meccha:rt pick.entry.weight 1
scoreboard players operation #TOTAL meccha.tmp += #W meccha.tmp
function meccha:eyedropper/select_apply_sum
