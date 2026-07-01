# meccha:lib/raycast/capture_ray
# Shared ray sampler. Run `at <player> anchored eyes`. Fills:
#   scores  #OX/#OY/#OZ (origin) and #DX/#DY/#DZ (direction), *1000
#   storage meccha:rt ray.{ox,oy,oz,dx,dy,dz} (doubles)
# Robust for multiplayer: a defensive pre-kill removes any stale ray markers a
# crashed cast may have left, so @e[tag=meccha_O] always resolves to OUR marker
# (casts run sequentially, so only one player's markers exist at a time).
kill @e[tag=meccha_ray]
summon minecraft:marker ^ ^ ^ {Tags:["meccha_ray","meccha_O"]}
execute positioned ^ ^ ^1 run summon minecraft:marker ^ ^ ^ {Tags:["meccha_ray","meccha_D"]}
execute store result score #OX meccha.math run data get entity @e[tag=meccha_O,limit=1] Pos[0] 1000
execute store result score #OY meccha.math run data get entity @e[tag=meccha_O,limit=1] Pos[1] 1000
execute store result score #OZ meccha.math run data get entity @e[tag=meccha_O,limit=1] Pos[2] 1000
execute store result score #DX meccha.math run data get entity @e[tag=meccha_D,limit=1] Pos[0] 1000
execute store result score #DY meccha.math run data get entity @e[tag=meccha_D,limit=1] Pos[1] 1000
execute store result score #DZ meccha.math run data get entity @e[tag=meccha_D,limit=1] Pos[2] 1000
scoreboard players operation #DX meccha.math -= #OX meccha.math
scoreboard players operation #DY meccha.math -= #OY meccha.math
scoreboard players operation #DZ meccha.math -= #OZ meccha.math

tellraw @a [{"text":"------ O=("},{"score":{"name":"#OX","objective":"meccha.math"}},{"text":","},{"score":{"name":"#OY","objective":"meccha.math"}},{"text":","},{"score":{"name":"#OZ","objective":"meccha.math"}},{"text":")"}]
execute store result storage meccha:rt ray.ox double 0.001 run scoreboard players get #OX meccha.math
execute store result storage meccha:rt ray.oy double 0.001 run scoreboard players get #OY meccha.math
execute store result storage meccha:rt ray.oz double 0.001 run scoreboard players get #OZ meccha.math
execute store result storage meccha:rt ray.dx double 0.001 run scoreboard players get #DX meccha.math
execute store result storage meccha:rt ray.dy double 0.001 run scoreboard players get #DY meccha.math
execute store result storage meccha:rt ray.dz double 0.001 run scoreboard players get #DZ meccha.math
kill @e[tag=meccha_ray]
