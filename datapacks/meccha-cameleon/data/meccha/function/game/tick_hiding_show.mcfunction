# meccha:game/tick_hiding_show
# Once per whole second (timer divisible by 20), push the countdown title.
scoreboard players set #C20 meccha.sys 20
scoreboard players operation #MOD meccha.sys = #T meccha.sys
scoreboard players operation #MOD meccha.sys %= #C20 meccha.sys
execute unless score #MOD meccha.sys matches 0 run return 0
# seconds = ceil(T / 20)
scoreboard players operation #SEC meccha.sys = #T meccha.sys
scoreboard players add #SEC meccha.sys 19
scoreboard players operation #SEC meccha.sys /= #C20 meccha.sys
execute store result storage meccha:rt cd.sec int 1 run scoreboard players get #SEC meccha.sys
function meccha:game/title_hiding with storage meccha:rt cd
