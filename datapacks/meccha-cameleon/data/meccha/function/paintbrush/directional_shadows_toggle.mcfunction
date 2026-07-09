# meccha:directional_shadows_toggle  (runs as the player)
execute if entity @s[tag=paint_with_automatic_directional_shadow] run return run function meccha:paintbrush/disable_directional_shadows
execute unless entity @s[tag=paint_with_automatic_directional_shadow] run return run function meccha:paintbrush/enable_directional_shadows

