# meccha:dialog/tick   (called every tick from meccha:tick)
# Keep the colour-picker triggers usable, and apply any pending clicks.
scoreboard players enable @a meccha.pick_rgb
scoreboard players enable @a meccha.pick_adj
execute as @a[scores={meccha.pick_rgb=1..}] run function meccha:dialog/apply_rgb
execute as @a[scores={meccha.pick_adj=1..}] run function meccha:dialog/apply_adj
