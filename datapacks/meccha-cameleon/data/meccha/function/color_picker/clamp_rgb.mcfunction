# meccha:color_picker/clamp_rgb
# Clamp #RRv/#GGv/#BBv into 0..255 (meccha.math).
execute if score #RRv meccha.math matches ..-1 run scoreboard players set #RRv meccha.math 0
execute if score #RRv meccha.math matches 256.. run scoreboard players set #RRv meccha.math 255
execute if score #GGv meccha.math matches ..-1 run scoreboard players set #GGv meccha.math 0
execute if score #GGv meccha.math matches 256.. run scoreboard players set #GGv meccha.math 255
execute if score #BBv meccha.math matches ..-1 run scoreboard players set #BBv meccha.math 0
execute if score #BBv meccha.math matches 256.. run scoreboard players set #BBv meccha.math 255
