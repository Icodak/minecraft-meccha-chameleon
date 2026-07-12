# meccha:game/hiders_win
# Hunt timer expired - the hiders survived.
title @a times 10 60 20
title @a[tag=meccha_hunter] title [{"text":"Hiders win!","color":"#ff6d68","bold":true}]
title @a[tag=!meccha_hunter] title [{"text":"Hiders win!","color":"#98ff68","bold":true}]
title @a subtitle [{"text":"The hunters ran out of time","color":"gray"}]
execute as @a[tag=meccha_hunter] at @s run playsound minecraft:event.mob_effect.raid_omen master @a[tag=!meccha_hunter] ~ ~ ~ 0.8 1
execute as @a[tag=!meccha_hunter] at @s run playsound minecraft:entity.player.levelup master @s ~ ~ ~ 100 1
function meccha:game/stop
function meccha:highlight_rig/start_highlight_blink