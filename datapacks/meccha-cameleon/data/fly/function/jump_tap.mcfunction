# fly:jump_tap - a fresh Jump press happened (double-tap detection)
# Used both to enter flight (when not flying) and to exit it (when flying).
# If the double-tap window is still open -> toggle flight state.
# Otherwise, (re)open the window for the next press.
execute if score @s fly.tap matches 1.. if entity @s[tag=fly.flying] run function fly:exit
execute if score @s fly.tap matches 1.. unless entity @s[tag=fly.flying] run function fly:enter
execute if score @s fly.tap matches 0 run scoreboard players set @s fly.tap 10
