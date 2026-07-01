# meccha:give/tools
# -------------------------------------------------------------------
# PILLAR 3.1 \u2014 the three interaction items.
# All use the 1.21.2+ `minecraft:consumable` component with an
# effectively-infinite consume time (1e7 s) and animation "none", so the
# player can hold right-click forever; each *finished* consume fires the
# matching consume_item advancement. We cancel the actual consumption by
# never letting it complete in normal play (the advancement+revoke loop
# below re-fires), and the food/health side effects are nil because the
# items are not food.
# -------------------------------------------------------------------

# Eyedropper (Arrow) \u2014 samples block colour from the world.
give @s minecraft:arrow[minecraft:consumable={consume_seconds:10000000.0f,animation:"none",has_consume_particles:false,sound:"minecraft:intentionally_empty"},minecraft:custom_data={eye_dropper:true},minecraft:item_name={"text":"Eyedropper","color":"aqua"},minecraft:max_stack_size=1] 1

# Paintbrush (Feather) \u2014 paints the custom player rig.
give @s minecraft:feather[minecraft:consumable={consume_seconds:10000000.0f,animation:"none",has_consume_particles:false,sound:"minecraft:intentionally_empty"},minecraft:custom_data={paint_brush:true},minecraft:item_name={"text":"Paintbrush","color":"light_purple"},minecraft:max_stack_size=1] 1

# Hunter Pointer (Blaze Rod) \u2014 fires the BVH hit test at hiders.
give @s minecraft:blaze_rod[minecraft:consumable={consume_seconds:10000000.0f,animation:"none",has_consume_particles:false,sound:"minecraft:intentionally_empty"},minecraft:custom_data={hunter_pointer:true},minecraft:item_name={"text":"Hunter Pointer","color":"gold"},minecraft:max_stack_size=1] 1
