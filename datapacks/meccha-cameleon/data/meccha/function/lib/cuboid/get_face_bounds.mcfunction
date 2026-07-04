# meccha:lib/cuboid/get_face_bounds   (macro: $(rid) $(cuboid) $(face))
# Reads the cuboid marker's data.size and derives $(face)'s pixel-grid
# bounds into scores #face.umax / #face.vmax.
# ASSUMPTION: data.size[0]/y/z are already in the same integer units as
# the u_/v_ tags (1 size unit = 1 pixel column/row). If your rig uses a
# different pixels-per-unit scale, change the trailing "1" scale args
# on every `data get` line below to your PPU constant.

$data modify storage meccha:rt cross.face set value "$(face)"

$execute if data storage meccha:rt {cross:{face:"north"}} as @e[tag=cb_$(cuboid),tag=r$(rid),type=marker,limit=1] store result score #face.umax meccha.math run data get entity @s data.size[0] 1
$execute if data storage meccha:rt {cross:{face:"north"}} as @e[tag=cb_$(cuboid),tag=r$(rid),type=marker,limit=1] store result score #face.vmax meccha.math run data get entity @s data.size[1] 1

$execute if data storage meccha:rt {cross:{face:"south"}} as @e[tag=cb_$(cuboid),tag=r$(rid),type=marker,limit=1] store result score #face.umax meccha.math run data get entity @s data.size[0] 1
$execute if data storage meccha:rt {cross:{face:"south"}} as @e[tag=cb_$(cuboid),tag=r$(rid),type=marker,limit=1] store result score #face.vmax meccha.math run data get entity @s data.size[1] 1

$execute if data storage meccha:rt {cross:{face:"east"}} as @e[tag=cb_$(cuboid),tag=r$(rid),type=marker,limit=1] store result score #face.umax meccha.math run data get entity @s data.size[2] 1
$execute if data storage meccha:rt {cross:{face:"east"}} as @e[tag=cb_$(cuboid),tag=r$(rid),type=marker,limit=1] store result score #face.vmax meccha.math run data get entity @s data.size[1] 1

$execute if data storage meccha:rt {cross:{face:"west"}} as @e[tag=cb_$(cuboid),tag=r$(rid),type=marker,limit=1] store result score #face.umax meccha.math run data get entity @s data.size[2] 1
$execute if data storage meccha:rt {cross:{face:"west"}} as @e[tag=cb_$(cuboid),tag=r$(rid),type=marker,limit=1] store result score #face.vmax meccha.math run data get entity @s data.size[1] 1

$execute if data storage meccha:rt {cross:{face:"top"}} as @e[tag=cb_$(cuboid),tag=r$(rid),type=marker,limit=1] store result score #face.umax meccha.math run data get entity @s data.size[0] 1
$execute if data storage meccha:rt {cross:{face:"top"}} as @e[tag=cb_$(cuboid),tag=r$(rid),type=marker,limit=1] store result score #face.vmax meccha.math run data get entity @s data.size[2] 1

$execute if data storage meccha:rt {cross:{face:"bottom"}} as @e[tag=cb_$(cuboid),tag=r$(rid),type=marker,limit=1] store result score #face.umax meccha.math run data get entity @s data.size[0] 1
$execute if data storage meccha:rt {cross:{face:"bottom"}} as @e[tag=cb_$(cuboid),tag=r$(rid),type=marker,limit=1] store result score #face.vmax meccha.math run data get entity @s data.size[2] 1