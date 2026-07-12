data modify storage meccha:save_locations saving set value {}
$data modify storage meccha:save_locations saving.name set value "$(name)"
summon marker ~ ~ ~ {Tags:[saving_location]}

data modify storage meccha:save_locations saving.x set from entity @e[type=marker,limit=1,tag=saving_location] Pos[0]
data modify storage meccha:save_locations saving.y set from entity @e[type=marker,limit=1,tag=saving_location] Pos[1]
data modify storage meccha:save_locations saving.z set from entity @e[type=marker,limit=1,tag=saving_location] Pos[2]
kill @e[type=marker,limit=1,tag=saving_location]

data modify storage meccha:save_locations saved append from storage meccha:save_locations saving