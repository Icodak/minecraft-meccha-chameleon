# meccha:init/constants
# Named fixed-point constants. SCALE = 1000  (3 decimal places).
scoreboard players set #SCALE meccha.math 1000
scoreboard players set #HALF meccha.math 500
# 1/16 block * 1000 (rounded 62.5)
scoreboard players set #PX meccha.math 62
scoreboard players set #ZERO meccha.math 0
scoreboard players set #FALSE meccha.math 0
scoreboard players set #TRUE meccha.math 1
scoreboard players set #NEGATIVE_ONE meccha.math -1
scoreboard players set #ONE meccha.math 1000
# Vanilla directional shading multipliers * 1000 (Pillar 6).
scoreboard players set #SHADE_TOP meccha.math 1000
scoreboard players set #SHADE_NS meccha.math 800
scoreboard players set #SHADE_EW meccha.math 600
scoreboard players set #SHADE_BOT meccha.math 500
# Hiding-player downscale factor vs Hunter (Pillar 5): 1/3.
scoreboard players set #RIG_SCALE_NUM meccha.math 1
scoreboard players set #RIG_SCALE_DEN meccha.math 3
