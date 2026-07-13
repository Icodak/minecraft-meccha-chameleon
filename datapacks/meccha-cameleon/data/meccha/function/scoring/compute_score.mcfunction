# # meccha:scoring/compute_score.mcfunction
summon armor_stand ^ ^ ^ {Tags:["scoring_direction_marker"]}
execute as @s run data modify storage meccha:score player_direction set from entity @s Rotation
execute as @e[type=marker,tag=meccha_rig_root] run function meccha:scoring/add_score_if_visible
kill @e[type=armor_stand, tag=scoring_direction_marker]