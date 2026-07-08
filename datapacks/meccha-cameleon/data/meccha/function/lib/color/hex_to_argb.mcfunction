# meccha:lib/color/hex_to_argb
# Parse "#RRGGBBAA" -> packed signed ARGB int in score #ARGB (meccha.math).
# IN: storage meccha:rt col.hex = "#RRGGBBAA"
# Uses `set string` to slice each byte, then the hex2int table. The final
# multiply/add intentionally overflows 32-bit: 2's-complement wrap yields the
# exact signed ARGB that text_display.background_color expects.
data modify storage meccha:rt col.rr set string storage meccha:rt col.hex 1 3
data modify storage meccha:rt col.gg set string storage meccha:rt col.hex 3 5
data modify storage meccha:rt col.bb set string storage meccha:rt col.hex 5 7
data modify storage meccha:rt col.aa set string storage meccha:rt col.hex 7 9
function meccha:lib/color/lookup_argb with storage meccha:rt col

scoreboard players set #M24 meccha.tmp 16777216
scoreboard players set #M16 meccha.tmp 65536
scoreboard players set #M8 meccha.tmp 256
scoreboard players operation #ARGB meccha.math = #AAv meccha.math
scoreboard players operation #ARGB meccha.math *= #M24 meccha.tmp
scoreboard players operation #RRt meccha.math = #RRv meccha.math
scoreboard players operation #RRt meccha.math *= #M16 meccha.tmp
scoreboard players operation #GGt meccha.math = #GGv meccha.math
scoreboard players operation #GGt meccha.math *= #M8 meccha.tmp
scoreboard players operation #ARGB meccha.math += #RRt meccha.math
scoreboard players operation #ARGB meccha.math += #GGt meccha.math
scoreboard players operation #ARGB meccha.math += #BBv meccha.math
