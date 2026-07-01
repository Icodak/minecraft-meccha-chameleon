# meccha:game/reset
# Full teardown: stop the round, clear all roles, and remove the rig.
function meccha:game/stop
function meccha:role/clear_all
function meccha:reset_rig
data modify storage meccha:game {} set value {phase:"idle", timer:0}
tellraw @a [{"text":"[Meccha] ","color":"green"},{"text":"game reset to idle.","color":"gray"}]
