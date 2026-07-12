scoreboard players operation #index meccha.selected_location_index = @s meccha.select_map
scoreboard players remove #index meccha.selected_location_index 1
scoreboard players set @s meccha.select_map 0
function meccha:start_screen/build_screen