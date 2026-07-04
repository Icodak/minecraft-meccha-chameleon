# meccha:dev/info_cuboid_body   (executed AS the cuboid marker)
tellraw @a [{"text":"pos ","color":"gray"},{"nbt":"Pos","entity":"@s","color":"white"},{"text":"  rot ","color":"gray"},{"nbt":"Rotation","entity":"@s","color":"white"}]
tellraw @a [{"text":"size ","color":"gray"},{"nbt":"data.size","entity":"@s","color":"aqua"},{"text":"  half ","color":"gray"},{"nbt":"data.half","entity":"@s","color":"aqua"}]
tellraw @a [{"text":"pixels here: ","color":"gray"},{"selector":"@e[tag=meccha_pixel,distance=..1]","color":"yellow"}]
