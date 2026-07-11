# meccha:game/end_hide
# Hide window over: restore hunter vision/movement and start the hunt.
data modify storage meccha:game phase set value "hunting"
effect clear @a[tag=meccha_hunter] minecraft:blindness
effect clear @a[tag=meccha_hunter] minecraft:darkness
effect clear @a[tag=meccha_hunter] minecraft:slowness
effect clear @a[tag=meccha_hunter] minecraft:jump_boost

# Round timer (ticks) = round_seconds * 20
execute store result score #RS meccha.sys run data get storage meccha:settings round_seconds 1
scoreboard players set #C20 meccha.sys 20
scoreboard players operation #RS meccha.sys *= #C20 meccha.sys
execute store result storage meccha:game timer int 1 run scoreboard players get #RS meccha.sys

title @a times 5 30 10
title @a title [{"text":"The hunt begins!","color":"red","bold":true}]
title @a[tag=meccha_hunter] subtitle [{"text":"Find every hider","color":"gold"}]
title @a[tag=meccha_hider] subtitle [{"text":"Hide and paint!","color":"green"}]
playsound minecraft:entity.ender_dragon.growl master @a ~ ~ ~ 0.7 1.2
