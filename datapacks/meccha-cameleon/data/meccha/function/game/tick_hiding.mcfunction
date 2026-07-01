# meccha:game/tick_hiding
# Count down the hide window; refresh the title once per second; at 0 release
# the hunters into the HUNTING phase.
execute store result score #T meccha.sys run data get storage meccha:game timer 1
scoreboard players remove #T meccha.sys 1
execute store result storage meccha:game timer int 1 run scoreboard players get #T meccha.sys

execute if score #T meccha.sys matches ..0 run function meccha:game/end_hide
execute unless score #T meccha.sys matches ..0 run function meccha:game/tick_hiding_show
