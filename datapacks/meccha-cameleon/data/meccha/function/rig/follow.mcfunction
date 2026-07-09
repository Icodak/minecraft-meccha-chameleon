# meccha:rig/follow   (called every tick from meccha:tick)
# Each bound player drags their rig to their feet and re-applies its pose so the
# whole rig follows. Cheap for a handful of hiders; scales with bound players.
execute as @a[tag=meccha_bound] if score @s meccha.hider_state = #RUNNING meccha.hider_state at @s run function meccha:rig/follow_owner