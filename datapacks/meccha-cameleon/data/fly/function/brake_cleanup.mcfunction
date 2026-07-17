# fly:brake_cleanup - remove the temporary velocity-braking shulkers
# Scheduled from fly:brake, 2 game ticks after they're summoned.
tp @e[type=armor_stand,tag=fly.brake] 0 -500 0
tp @e[type=shulker,tag=fly.brake] 0 -500 0
kill @e[type=shulker,tag=fly.brake]
kill @e[type=armor_stand,tag=fly.brake]
