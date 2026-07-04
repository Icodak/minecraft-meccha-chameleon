# meccha:lib/uv/invert
# out = max - 1 - val, using #inv.max / #inv.val (meccha.math) as input.
scoreboard players operation #inv.out meccha.math = #inv.max meccha.math
scoreboard players remove #inv.out meccha.math 1
scoreboard players operation #inv.out meccha.math -= #inv.val meccha.math