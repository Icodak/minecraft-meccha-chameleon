# meccha:game/tick_toggle_leave_spec_mode
scoreboard players enable @a meccha.toggle_leave_spec_mode
execute as @a[scores={meccha.toggle_leave_spec_mode=1..}] run function meccha:game/enter_running_mode
execute as @a[scores={meccha.toggle_leave_spec_mode=1..}] run scoreboard players set @s meccha.toggle_leave_spec_mode 0