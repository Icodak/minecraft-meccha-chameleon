scoreboard players reset @s meccha.rig
function meccha:dev/clear
tag @s remove meccha_bound
tag @s remove meccha_hider
gamemode spectator
title @s title {"text":"You've been found", color:"red"}