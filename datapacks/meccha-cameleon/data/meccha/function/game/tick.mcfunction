# meccha:game/tick   (called every tick from meccha:tick)
# Drives the round countdown for the active phase.
execute if data storage meccha:game {phase:"hiding"} run function meccha:game/tick_hiding
execute if data storage meccha:game {phase:"hunting"} run function meccha:game/tick_hunting

execute if data storage meccha:game {prevent_item_drop:1b} run function meccha:prevent_item_drop/instant_pickup_on_drop