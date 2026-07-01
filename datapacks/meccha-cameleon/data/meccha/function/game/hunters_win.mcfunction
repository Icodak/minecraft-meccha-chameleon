# meccha:game/hunters_win
# All hiders found - call this from your elimination logic when none remain.
title @a times 10 60 20
title @a title [{"text":"Hunters win!","color":"red","bold":true}]
title @a subtitle [{"text":"Every hider was found","color":"gray"}]
playsound minecraft:entity.ender_dragon.death master @a ~ ~ ~ 0.8 1
function meccha:game/stop
