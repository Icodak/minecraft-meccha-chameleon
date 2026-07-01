# meccha:game/tick_hunting_show
# Once per second, show the remaining hunt time on the action bar (keeps the
# centre of the screen clear during play).
scoreboard players set #C20 meccha.sys 20
scoreboard players operation #MOD meccha.sys = #T meccha.sys
scoreboard players operation #MOD meccha.sys %= #C20 meccha.sys
execute unless score #MOD meccha.sys matches 0 run return 0
scoreboard players operation #SEC meccha.sys = #T meccha.sys
scoreboard players add #SEC meccha.sys 19
scoreboard players operation #SEC meccha.sys /= #C20 meccha.sys
execute store result storage meccha:rt cd.sec int 1 run scoreboard players get #SEC meccha.sys
function meccha:game/actionbar_hunting with storage meccha:rt cd
