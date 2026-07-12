# meccha:hunter/fire   (advancement reward target; run at <player> anchored eyes)
# PILLAR 7 - fire the BVH hit test along the look ray.
function meccha:lib/raycast/capture_ray

execute anchored eyes positioned ^ ^ ^ run function #bs.raycast:run {with:{on_entry_point:"particle minecraft:flame ~ ~ ~"}}

data modify storage meccha:rt hunter set value {found:0b}
scoreboard players set #BEST_T meccha.math 2000000000

# Broad phase over every active hider (never the shooter's own rig if tagged).
execute as @e[tag=meccha_rig_root,tag=hider] at @s run function meccha:hunter/broad_phase

execute if data storage meccha:rt {hunter:{found:1b}} run function meccha:hunter/on_hit
execute unless data storage meccha:rt {hunter:{found:1b}} run function meccha:hunter/on_miss

execute unless entity @a[tag=meccha_hider] run function meccha:game/hunters_win