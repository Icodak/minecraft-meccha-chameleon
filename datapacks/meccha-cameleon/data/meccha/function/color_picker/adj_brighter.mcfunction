# meccha:color_picker/adj_brighter
# c' = clamp(c * 120/100 + 8, 0, 255)  (additive term lifts near-blacks).
scoreboard players set #MUL meccha.tmp 120
scoreboard players set #DIV meccha.tmp 100
scoreboard players operation #RRv meccha.math *= #MUL meccha.tmp
scoreboard players operation #RRv meccha.math /= #DIV meccha.tmp
scoreboard players add #RRv meccha.math 8
scoreboard players operation #GGv meccha.math *= #MUL meccha.tmp
scoreboard players operation #GGv meccha.math /= #DIV meccha.tmp
scoreboard players add #GGv meccha.math 8
scoreboard players operation #BBv meccha.math *= #MUL meccha.tmp
scoreboard players operation #BBv meccha.math /= #DIV meccha.tmp
scoreboard players add #BBv meccha.math 8
function meccha:color_picker/clamp_rgb
