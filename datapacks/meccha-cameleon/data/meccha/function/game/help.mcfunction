# meccha:game/help
# Operator command index for running a round.
tellraw @s [{"text":"-- Meccha Gameplay --","color":"gold","bold":true}]
tellraw @s [{"text":"Roles  ","color":"aqua"},{"text":"execute as <player> run function meccha:role/make_hunter | make_hider","color":"gray"}]
tellraw @s [{"text":"Clear  ","color":"aqua"},{"text":"role/clear (as player)   role/clear_all","color":"gray"}]
tellraw @s [{"text":"Round  ","color":"aqua"},{"text":"game/start   game/stop   game/reset","color":"gray"}]
tellraw @s [{"text":"Win    ","color":"aqua"},{"text":"game/hunters_win   game/hiders_win","color":"gray"}]
tellraw @s [{"text":"Config ","color":"aqua"},{"text":"game/set_hide_time {seconds}   game/set_round_time {seconds}   game/settings","color":"gray"}]
tellraw @s [{"text":"Pose   ","color":"aqua"},{"text":"hiders right-click the Pose Switcher to cycle stance","color":"gray"}]
