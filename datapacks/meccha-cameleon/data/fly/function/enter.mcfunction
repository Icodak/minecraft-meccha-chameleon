# fly:enter - switch the player into flight mode
tag @s add fly.flying

# Arm the double-tap window; this entry press counts as the first tap
scoreboard players set @s fly.tap 10

# Mark Jump as already held so the double-tap handler does NOT fire this same tick
scoreboard players set @s fly.jumpPrev 1

# Start from a clean movement state (hover) so the first hover tick can't
# mistakenly think we're coming from a leftover rise/slow-fall state
scoreboard players set @s fly.state 0

title @s actionbar [{"text":"Flight enabled","color":"aqua"}]
