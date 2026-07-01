# meccha:dialog/adj_darker
# c' = c * 82/100
scoreboard players set #MUL meccha.tmp 82
scoreboard players set #DIV meccha.tmp 100
scoreboard players operation #RRv meccha.math *= #MUL meccha.tmp
scoreboard players operation #RRv meccha.math /= #DIV meccha.tmp
scoreboard players operation #GGv meccha.math *= #MUL meccha.tmp
scoreboard players operation #GGv meccha.math /= #DIV meccha.tmp
scoreboard players operation #BBv meccha.math *= #MUL meccha.tmp
scoreboard players operation #BBv meccha.math /= #DIV meccha.tmp
function meccha:dialog/clamp_rgb
