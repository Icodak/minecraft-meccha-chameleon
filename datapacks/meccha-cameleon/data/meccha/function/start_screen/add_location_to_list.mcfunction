execute store result storage meccha:start_screen saved_locations[0].is_selected byte 1 run execute if score #trigger_index meccha.start_screen.location_trigger_value = #index meccha.selected_location_index
execute if score #trigger_index meccha.start_screen.location_trigger_value = #index meccha.selected_location_index run data modify storage meccha:start_screen saved_locations[0].color set value "aqua"
execute unless score #trigger_index meccha.start_screen.location_trigger_value = #index meccha.selected_location_index run data modify storage meccha:start_screen saved_locations[0].color set value "white"


# Add one after checking the index because of the +1 offset of trigger values
scoreboard players add #trigger_index meccha.start_screen.location_trigger_value 1
execute store result storage meccha:start_screen saved_locations[0].trigger_index int 1 run scoreboard players get #trigger_index meccha.start_screen.location_trigger_value

function meccha:start_screen/append_location with storage meccha:start_screen saved_locations[0]

data remove storage meccha:start_screen saved_locations[0]
execute if data storage meccha:start_screen saved_locations[0] run function meccha:start_screen/add_location_to_list