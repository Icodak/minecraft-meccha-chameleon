clear @s

tag @s add needs_pose_cycle
schedule function meccha:items/hider/pose_cycle 1t

tag @s add needs_taunt_item
schedule function meccha:items/hider/taunt_item 1t

function meccha:items/hider/enter_painting_mode_item

function meccha:items/hider/enter_spectator_mode_item