# meccha:lib/math/slab_axis_parallel
# Ray parallel to this slab: a miss unless the origin lies inside [-SH, SH].
scoreboard players operation #SHN meccha.math = #SH meccha.math
scoreboard players set #NEG meccha.tmp -1
scoreboard players operation #SHN meccha.math *= #NEG meccha.tmp
execute unless score #SO meccha.math >= #SHN meccha.math run scoreboard players set #SLAB_OK meccha.tmp 0
execute unless score #SO meccha.math <= #SH meccha.math run scoreboard players set #SLAB_OK meccha.tmp 0
