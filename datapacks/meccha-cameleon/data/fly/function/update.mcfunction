# fly:update - runs each tick while flying
# Touching the ground cancels flight and resets everything.
execute at @s unless block ~ ~-0.1 ~ #bs.hitbox:can_pass_through run function fly:exit

# Still flying? apply the movement state matching the current keys.
execute if entity @s[tag=fly.flying] run function fly:apply_state
