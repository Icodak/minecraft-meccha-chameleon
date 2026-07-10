# meccha:trigger/enter_spectator_mode  (advancement reward, runs as the player)
advancement revoke @s only meccha:enter_spectator_mode
scoreboard players set @s meccha.toggle_leave_spec_mode 0

function meccha:game/enter_hider_spectator_mode