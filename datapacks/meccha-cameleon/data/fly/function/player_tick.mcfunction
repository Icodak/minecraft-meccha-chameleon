# fly:player_tick - per-player logic (executed as the player)

# Make sure the double-tap window score exists (defaults to 0 the first time)
scoreboard players add @s fly.tap 0

# Age the double-tap window (0.3s = 6 ticks), whether currently flying or not
execute if score @s fly.tap matches 1.. run scoreboard players remove @s fly.tap 1

# Not flying: a fresh Jump press (rising edge) while airborne counts as a tap towards entering flight
execute unless entity @s[tag=fly.flying] if predicate fly:pressing_jump if score @s fly.jumpPrev matches 0 at @s if block ~ ~-0.1 ~ #bs.hitbox:can_pass_through run function fly:jump_tap

# While flying: a fresh Jump press counts as a tap towards exiting flight
execute if entity @s[tag=fly.flying] if predicate fly:pressing_jump if score @s fly.jumpPrev matches 0 run function fly:jump_tap

# While flying: ground check + apply the active movement state
execute if entity @s[tag=fly.flying] run function fly:update

# Store this tick's Jump state for next tick's edge detection
scoreboard players set @s fly.jumpPrev 0
execute if predicate fly:pressing_jump run scoreboard players set @s fly.jumpPrev 1
