# meccha:lib/math/dot3
# Fast in-line fixed-point 3D dot product (block-local space, *1000).
# IN : #AX/#AY/#AZ, #BX/#BY/#BZ   OUT: #DOT = (A . B)   (still *1000)
# NOTE: the Bookshelf-backed equivalent is meccha:lib/vector/dot_product;
# this score-only version avoids per-face storage round-trips in the hot
# eyedropper / SAT loops. Operands MUST be block-local (|comp| < ~16) to
# stay within the 32-bit scoreboard range.
scoreboard players operation #DOT meccha.math = #AX meccha.math
scoreboard players operation #DOT meccha.math *= #BX meccha.math
scoreboard players operation #TMPY meccha.math = #AY meccha.math
scoreboard players operation #TMPY meccha.math *= #BY meccha.math
scoreboard players operation #TMPZ meccha.math = #AZ meccha.math
scoreboard players operation #TMPZ meccha.math *= #BZ meccha.math
scoreboard players operation #DOT meccha.math += #TMPY meccha.math
scoreboard players operation #DOT meccha.math += #TMPZ meccha.math
scoreboard players operation #DOT meccha.math /= #SCALE meccha.math
