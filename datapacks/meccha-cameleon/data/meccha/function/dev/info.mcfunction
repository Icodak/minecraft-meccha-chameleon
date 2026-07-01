# meccha:dev/info
# One-shot overview of rig + registry state.
# `store result ... if entity` yields the COUNT of matching entities.
execute store result score #CUBES meccha.tmp if entity @e[tag=meccha_cuboid]
execute store result score #PIX meccha.tmp if entity @e[tag=meccha_pixel]
execute store result score #OVL meccha.tmp if entity @e[tag=meccha_overlay]
execute store result score #RIGS meccha.tmp if entity @e[tag=meccha_rig_root]

tellraw @s [{"text":"-- Meccha Info --","color":"gold","bold":true}]
tellraw @s [{"text":"registry loaded: ","color":"gray"},{"nbt":"meta.loaded","storage":"meccha:registry","color":"yellow"},{"text":" (1=ready)","color":"dark_gray"}]
tellraw @s [{"text":"rigs: ","color":"gray"},{"score":{"name":"#RIGS","objective":"meccha.tmp"},"color":"aqua"}]
tellraw @s [{"text":"cuboids ","color":"gray"},{"score":{"name":"#CUBES","objective":"meccha.tmp"},"color":"yellow"},{"text":"  pixels ","color":"gray"},{"score":{"name":"#PIX","objective":"meccha.tmp"},"color":"yellow"},{"text":"  overlays ","color":"gray"},{"score":{"name":"#OVL","objective":"meccha.tmp"},"color":"yellow"}]
tellraw @s [{"text":"last brush colour: ","color":"gray"},{"nbt":"last_sample","storage":"meccha:rt","color":"white"}]
