scoreboard players operation #index meccha.selected_location_index = @s meccha.select_map
scoreboard players remove #index meccha.selected_location_index 1
scoreboard players set @s meccha.select_map 0

execute store result storage meccha:game selected_location_index int 1 run scoreboard players get #index meccha.selected_location_index
function meccha:start_screen/on_tap/store_selected_map with storage meccha:game

function meccha:start_screen/show

