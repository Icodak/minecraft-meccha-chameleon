# meccha:game/tick_hunting
# Count down the hunt; show remaining time on the action bar. If time runs out
# the hiders survive and win.
execute store result score #T meccha.sys run data get storage meccha:game timer 1
scoreboard players remove #T meccha.sys 1
execute store result storage meccha:game timer int 1 run scoreboard players get #T meccha.sys

execute if score #T meccha.sys matches ..0 run function meccha:game/hiders_win
execute unless score #T meccha.sys matches ..0 run function meccha:game/tick_hunting_show
