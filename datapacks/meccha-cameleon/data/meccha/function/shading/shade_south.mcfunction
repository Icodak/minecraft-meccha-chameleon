# meccha:shading/shade_south
scoreboard players set #NLX meccha.math 0
scoreboard players set #NLY meccha.math 0
scoreboard players set #NLZ meccha.math 1000
data modify storage meccha:rt sh.dir set value "south"
function meccha:lib/math/rot_normal
function meccha:shading/classify