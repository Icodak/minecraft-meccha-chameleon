# meccha:dev/info_cuboid_body   (executed AS the cuboid marker)
tellraw @s [{"text":"pos ","color":"gray"},{"nbt":"Pos","entity":"@s","color":"white"},{"text":"  rot ","color":"gray"},{"nbt":"Rotation","entity":"@s","color":"white"}]
tellraw @s [{"text":"size ","color":"gray"},{"nbt":"data.size","entity":"@s","color":"aqua"},{"text":"  half ","color":"gray"},{"nbt":"data.half","entity":"@s","color":"aqua"},{"text":"  hp ","color":"gray"},{"nbt":"data.hp","entity":"@s","color":"red"}]
tellraw @s [{"text":"pixels here: ","color":"gray"},{"selector":"@e[tag=meccha_pixel,distance=..1]","color":"yellow"}]
