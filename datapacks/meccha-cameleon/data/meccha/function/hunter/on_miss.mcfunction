# meccha:hunter/on_hit   (executed AS the shooter)
# React to the nearest limb hit: feedback + dock that limb's hp.
title @s actionbar {"text":"❌ Miss","color":"red"}
playsound minecraft:block.fire.extinguish master @s ~ ~ ~ 1 2
