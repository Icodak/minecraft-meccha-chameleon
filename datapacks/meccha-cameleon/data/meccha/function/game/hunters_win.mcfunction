# meccha:game/hunters_win
# All hiders found - call this from your elimination logic when none remain.
title @s times 2s 5s 1s
title @a[tag=meccha_hunter] title [{"text":"Hunters win!","color":"#98ff68","bold":true}]
title @a[tag=!meccha_hunter] title [{"text":"Hunters win!","color":"#ff6d68","bold":true}]
title @a subtitle [{"text":"Every hider was found","color":"gray"}]
execute as @a[tag=meccha_hunter] at @s run playsound minecraft:entity.player.levelup master @s ~ ~ ~ 100 1
execute as @a[tag=!meccha_hunter] at @s run playsound minecraft:event.mob_effect.raid_omen master @a[tag=!meccha_hunter] ~ ~ ~ 0.8 1
function meccha:game/stop
