gamemode spectator @s
scoreboard players operation @s meccha.hider_state = #SPECTATING meccha.hider_state
playsound block.sniffer_egg.plop master @s ~ ~ ~ 1 2
tellraw @s [{"text":"You are now in spectator mode!\nYou can pass through walls and teleport to other players but remember, you're still hiding\nClick the button below to go back to painting mode\n","color":"#a5a5a5",italic:true},{"text":" [Leave spectator mode]","color":"#78ff56",click_event:{"action":"run_command","command":"trigger meccha.toggle_leave_spec_mode"}}]
