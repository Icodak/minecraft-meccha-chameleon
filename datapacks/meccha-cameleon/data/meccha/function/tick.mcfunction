# meccha:tick
# Per-tick driver. Kept lean; heavy work is event-driven (advancements).

# Gameplay: pose-switch item (discrete right-click) + round countdown.
function meccha:game/tick
function meccha:color_picker/tick
function meccha:start_screen/tick

# Ensure every player has a default brush color (white) exactly once.
execute as @a unless score @s meccha.color matches 0.. run scoreboard players set @s meccha.color 16777215

# Bound rigs follow their owner (per-rig).
function meccha:rig/follow

function meccha:climb_on_walls/enable_climbing