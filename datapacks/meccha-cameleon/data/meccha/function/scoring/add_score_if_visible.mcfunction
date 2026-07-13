# meccha:scoring/add_score_if_visible.mcfunction

execute at @e[type=armor_stand,tag=scoring_direction_marker] run tp @e[type=armor_stand,tag=scoring_direction_marker] ^ ^ ^ facing entity @s
execute as @e[type=armor_stand,tag=scoring_direction_marker] run data modify storage meccha:score hider_direction set from entity @s Rotation

execute store result score #hider_dir_yaw meccha.math run data get storage meccha:score hider_direction[0]
execute store result score #hider_dir_pitch meccha.math run data get storage meccha:score hider_direction[1]
execute store result score #player_dir_yaw meccha.math run data get storage meccha:score player_direction[0]
execute store result score #player_dir_pitch meccha.math run data get storage meccha:score player_direction[1]

scoreboard players operation #hider_dir_yaw meccha.math -= #player_dir_yaw meccha.math
scoreboard players operation #hider_dir_pitch meccha.math -= #player_dir_pitch meccha.math

execute if score #hider_dir_yaw meccha.math matches ..-180 run scoreboard players add #hider_dir_yaw meccha.math 360
execute if score #hider_dir_yaw meccha.math matches 180.. run scoreboard players remove #hider_dir_yaw meccha.math 360

# Visibility cone for 90 FOV is roughly 65° yaw and 45° pitch, I put this a bit larger to have the hiders gain more points
# And honestly who plays at default FOV anyways ?
scoreboard players set #result bs.data 0 
data modify storage meccha:score entity_is_visible set value 0b
data modify storage meccha:score entity_is_within_fov set value 0b
execute store result storage meccha:score entity_is_within_fov byte 1 run execute if score #hider_dir_yaw meccha.math matches -65..65 if score #hider_dir_pitch meccha.math matches -45..45
execute if data storage meccha:score {entity_is_within_fov:1b} at @s facing entity @e[type=armor_stand,tag=scoring_direction_marker,limit=1] eyes run function #bs.raycast:run {with:{blocks:true,entities:true,piercing:{blocks:0,entities:0},ignored_entities:"minecraft:player",on_targeted_entity:"execute if entity @s[tag=scoring_direction_marker] run data modify storage meccha:score entity_is_visible set value 1b"}}

# say @s
execute if data storage meccha:score {entity_is_visible:1b} run scoreboard players add @s meccha.scoring 1

# debug
# execute if data storage meccha:score {entity_is_within_fov:1b} run say Within FOV
# execute if data storage meccha:score {entity_is_within_fov:0b} run say OUTSIDE FOV
# execute if data storage meccha:score {entity_is_visible:1b} run say Visible
# execute if data storage meccha:score {entity_is_visible:0b} run say Hidden
# tellraw @a [{text:"yaw delta: "},{score:{objective:"meccha.math",name:"#hider_dir_yaw"}},{text:"pitch delta: "},{score:{objective:"meccha.math",name:"#hider_dir_pitch"}}]