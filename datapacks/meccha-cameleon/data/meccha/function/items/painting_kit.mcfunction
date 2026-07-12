clear @s
function meccha:items/hider/brush_item
tag @s add needs_open_brush_settings
tag @s add needs_pose_cycle
schedule function meccha:items/hider/brush_settings_item 1t
schedule function meccha:items/hider/pose_cycle 1t
function meccha:items/hider/enter_running_mode_item
function meccha:items/hider/enter_spectator_mode_item