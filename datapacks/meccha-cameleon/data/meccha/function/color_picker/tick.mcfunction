# meccha:color_picker/tick   (called every tick from meccha:tick)
# Keep the color-picker triggers usable, and apply any pending clicks.
scoreboard players enable @a meccha.pick_rgb
scoreboard players enable @a meccha.pick_adj
scoreboard players enable @a meccha.brush_type
execute as @a[scores={meccha.pick_rgb=1..}] run function meccha:color_picker/apply_rgb
execute as @a[scores={meccha.pick_adj=1..}] run function meccha:color_picker/apply_adj
