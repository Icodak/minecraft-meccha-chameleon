# Hunters
data modify storage meccha:start_screen hunters_list_to_concat set value []
execute as @a[tag=meccha_hunter] run function meccha:start_screen/add_hunter_player_to_list
data modify storage meccha:lib string.concat.list set from storage meccha:start_screen hunters_list_to_concat
function meccha:lib/string/concatenate_list_into_string
data modify storage meccha:start_screen hunters_list set from storage meccha:lib string.concat.out

# Hiders
data modify storage meccha:start_screen hiders_list_to_concat set value []
execute as @a[tag=meccha_hider] run function meccha:start_screen/add_hider_player_to_list
data modify storage meccha:lib string.concat.list set from storage meccha:start_screen hiders_list_to_concat
function meccha:lib/string/concatenate_list_into_string
data modify storage meccha:start_screen hiders_list set from storage meccha:lib string.concat.out

# Locations
data modify storage meccha:start_screen saved_locations set from storage meccha:save_locations saved
data modify storage meccha:start_screen locations_list_to_concat set value []
scoreboard players set #trigger_index meccha.start_screen.location_trigger_value 0
function meccha:start_screen/add_location_to_list
data modify storage meccha:lib string.concat.list set from storage meccha:start_screen locations_list_to_concat
function meccha:lib/string/concatenate_list_into_string
data modify storage meccha:start_screen locations_list set from storage meccha:lib string.concat.out

# Starting
data modify storage meccha:start_screen can_start set value 0b
data modify storage meccha:start_screen start_color set value "red"
execute unless entity @a[tag=meccha_hunter] run data modify storage meccha:start_screen start_label set value "Add one hunter to start the game"
execute unless entity @a[tag=meccha_hider] run data modify storage meccha:start_screen start_label set value "Add one hider to start the game"
execute unless data storage meccha:save_locations saved[0] run data modify storage meccha:start_screen start_label set value "Please save one location to play"

execute if entity @a[tag=meccha_hunter] if entity @a[tag=meccha_hider] if data storage meccha:save_locations saved[0] run data modify storage meccha:start_screen start_color set value "white"
execute if entity @a[tag=meccha_hunter] if entity @a[tag=meccha_hider] if data storage meccha:save_locations saved[0] run data modify storage meccha:start_screen start_label set value "Start round"
execute if entity @a[tag=meccha_hunter] if entity @a[tag=meccha_hider] if data storage meccha:save_locations saved[0] run data modify storage meccha:start_screen can_start set value 1b

# build the screen
function meccha:start_screen/open_start_screen_dialog_macro with storage meccha:start_screen