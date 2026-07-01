# meccha:role/clear_all
# Strip roles from EVERY player (used at game end / reset).
execute as @a run function meccha:role/clear
tellraw @a [{"text":"[Meccha] ","color":"green"},{"text":"all roles cleared.","color":"gray"}]
