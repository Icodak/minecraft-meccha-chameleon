# meccha:dialog/sat_apply
# c' = luma + (c - luma) * F/100, with luma = 0.299R + 0.587G + 0.114B.
# IN: #RRv/#GGv/#BBv (0..255, meccha.math), #F (percent, meccha.tmp).
scoreboard players set #W_R meccha.tmp 299
scoreboard players set #W_G meccha.tmp 587
scoreboard players set #W_B meccha.tmp 114
scoreboard players set #W_D meccha.tmp 1000
scoreboard players set #C100 meccha.tmp 100

scoreboard players operation #T1 meccha.math = #RRv meccha.math
scoreboard players operation #T1 meccha.math *= #W_R meccha.tmp
scoreboard players operation #T2 meccha.math = #GGv meccha.math
scoreboard players operation #T2 meccha.math *= #W_G meccha.tmp
scoreboard players operation #T3 meccha.math = #BBv meccha.math
scoreboard players operation #T3 meccha.math *= #W_B meccha.tmp
scoreboard players operation #LUMA meccha.math = #T1 meccha.math
scoreboard players operation #LUMA meccha.math += #T2 meccha.math
scoreboard players operation #LUMA meccha.math += #T3 meccha.math
scoreboard players operation #LUMA meccha.math /= #W_D meccha.tmp

scoreboard players operation #RRv meccha.math -= #LUMA meccha.math
scoreboard players operation #RRv meccha.math *= #F meccha.tmp
scoreboard players operation #RRv meccha.math /= #C100 meccha.tmp
scoreboard players operation #RRv meccha.math += #LUMA meccha.math
scoreboard players operation #GGv meccha.math -= #LUMA meccha.math
scoreboard players operation #GGv meccha.math *= #F meccha.tmp
scoreboard players operation #GGv meccha.math /= #C100 meccha.tmp
scoreboard players operation #GGv meccha.math += #LUMA meccha.math
scoreboard players operation #BBv meccha.math -= #LUMA meccha.math
scoreboard players operation #BBv meccha.math *= #F meccha.tmp
scoreboard players operation #BBv meccha.math /= #C100 meccha.tmp
scoreboard players operation #BBv meccha.math += #LUMA meccha.math
function meccha:dialog/clamp_rgb
