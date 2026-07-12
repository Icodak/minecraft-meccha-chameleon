tag @s remove meccha_hunter
tag @s remove meccha_hider
execute if score @s meccha.select_team matches 1 run tag @s add meccha_hider
execute if score @s meccha.select_team matches 2 run tag @s add meccha_hunter
scoreboard players set @s meccha.select_team 0

function meccha:start_screen/build_screen