# meccha:game/hiders_win
# Hunt timer expired - the hiders survived.
title @a times 10 60 20
title @a title [{"text":"Hiders win!","color":"green","bold":true}]
title @a subtitle [{"text":"The hunters ran out of time","color":"gray"}]
playsound minecraft:ui.toast.challenge_complete master @a ~ ~ ~ 1 1
function meccha:game/stop
function meccha:highlight_rig/start_highlight_blink
