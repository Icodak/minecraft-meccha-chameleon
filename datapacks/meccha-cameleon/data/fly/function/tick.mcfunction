# fly:tick - entry point, runs every tick

# Only players carrying the "can_fly" tag may use the flight system.
execute as @a[tag=can_fly] at @s run function fly:player_tick

# Anyone still flying who lost the "can_fly" tag is reset immediately.
execute as @a[tag=fly.flying,tag=!can_fly] at @s run function fly:exit
