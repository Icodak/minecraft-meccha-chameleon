# meccha:hunter/on_hit   (executed AS the shooter)
# React to the nearest limb hit: feedback + dock that limb's hp.
function meccha:hunter/on_hit_msg with storage meccha:rt hunter
playsound minecraft:entity.firework_rocket.blast master @s ~ ~ ~ 1 0.8
function meccha:hunter/kill_hider with storage meccha:rt hunter
