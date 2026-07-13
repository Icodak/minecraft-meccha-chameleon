scoreboard players operation #TMP meccha.scoring_public = @s meccha.scoring
execute store result score #RID meccha.scoring_public run data get entity @s data.rid
execute as @a[tag=meccha_hider] if score @s meccha.rig = #RID meccha.scoring_public run scoreboard players operation @s meccha.scoring_public = #TMP meccha.scoring_public 