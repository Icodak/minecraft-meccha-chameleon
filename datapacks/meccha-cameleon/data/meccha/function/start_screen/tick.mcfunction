scoreboard players enable @a meccha.select_team
scoreboard players enable @a meccha.select_map
scoreboard players enable @a meccha.select_start

execute as @a if score @s meccha.select_team matches 1.. run function meccha:start_screen/on_tap/select_team
execute as @a if score @s meccha.select_map matches 1.. run function meccha:start_screen/on_tap/select_map
execute as @a if score @s meccha.select_start matches 1.. run function meccha:start_screen/on_tap/select_start
