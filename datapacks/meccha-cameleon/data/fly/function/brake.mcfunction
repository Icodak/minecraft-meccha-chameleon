# fly:brake - arrest vertical velocity by pinning the player between two shulkers
# Called (with "at @s") the tick we switch from rise/slow-fall into hover.
# One shulker is summoned snug under the feet, one snug above the head, with
# a hair's overlap so collision resolution kicks in immediately this tick.
# They are cleaned up at the very start of the NEXT tick, see fly:tick.
summon armor_stand ~ ~1.05 ~ {NoGravity:1b,Invisible:1b,Marker:1b,Tags:["fly.brake"],Passengers:[{id:"minecraft:shulker",NoGravity:1b,Silent:1b,NoAI:1b,AttachFace:0b,Tags:["fly.brake"],active_effects:[{id:"minecraft:invisibility",amplifier:1,duration:-1,show_particles:0b,show_icon:0b,ambient:0b}]}]}
summon armor_stand ~ ~-1.1 ~ {NoGravity:1b,Invisible:1b,Marker:1b,Tags:["fly.brake"],Passengers:[{id:"minecraft:shulker",NoGravity:1b,Silent:1b,NoAI:1b,AttachFace:0b,Tags:["fly.brake"],active_effects:[{id:"minecraft:invisibility",amplifier:1,duration:-1,show_particles:0b,show_icon:0b,ambient:0b}]}]}

schedule function fly:brake_cleanup 2t replace