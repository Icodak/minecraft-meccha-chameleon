# meccha:eyedropper/select_apply_weighted
# Weighted model selection for blockstate variant / multipart apply arrays.
# Uses the hit block position as a stable seed so the same block always picks
# the same model, matching vanilla's position-stable random model choice.

data modify storage meccha:rt pick.apply set from storage meccha:rt sel.apply

scoreboard players operation #HASH meccha.tmp = #BX meccha.math
scoreboard players set #C1 meccha.tmp 734287
scoreboard players operation #HASH meccha.tmp *= #C1 meccha.tmp
scoreboard players operation #HASH meccha.tmp += #BY meccha.math
scoreboard players set #C2 meccha.tmp 912931
scoreboard players operation #HASH meccha.tmp *= #C2 meccha.tmp
scoreboard players operation #HASH meccha.tmp += #BZ meccha.math
scoreboard players set #NEG1 meccha.tmp -1
execute if score #HASH meccha.tmp matches ..-1 run scoreboard players operation #HASH meccha.tmp *= #NEG1 meccha.tmp

scoreboard players set #TOTAL meccha.tmp 0
function meccha:eyedropper/select_apply_sum

execute unless score #TOTAL meccha.tmp matches 1.. run data modify storage meccha:rt sel.model set from storage meccha:rt sel.apply[0].model
execute unless score #TOTAL meccha.tmp matches 1.. run return 0

scoreboard players operation #HASH meccha.tmp %= #TOTAL meccha.tmp
data modify storage meccha:rt pick.apply set from storage meccha:rt sel.apply
function meccha:eyedropper/select_apply_pick
