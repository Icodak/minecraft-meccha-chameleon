execute unless block ~ ~ ~ air run return fail
execute if score @s meccha.los_step matches 40.. run return fail

scoreboard players add @s meccha.los_step 1

execute if entity @e[tag=scoring_direction_marker,dx=0,dy=0,dz=0,limit=1] run return run scoreboard players set @s meccha.los_result 1

execute positioned ^ ^ ^0.5 run function meccha:scoring/step