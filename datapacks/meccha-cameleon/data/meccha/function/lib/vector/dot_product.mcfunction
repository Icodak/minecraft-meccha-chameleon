# meccha:lib/vector/dot_product
# Wrapper over Bookshelf #bs.vector:dot_product (real API: scores on bs.in,
# result on bs.out, fixed-point scale via the {scaling} macro).
# IN : #AX/#AY/#AZ, #BX/#BY/#BZ  (meccha.math, *1000)
# OUT: #DOT  (meccha.math, *1000)
scoreboard players operation $vector.dot_product.u.0 bs.in = #AX meccha.math
scoreboard players operation $vector.dot_product.u.1 bs.in = #AY meccha.math
scoreboard players operation $vector.dot_product.u.2 bs.in = #AZ meccha.math
scoreboard players operation $vector.dot_product.v.0 bs.in = #BX meccha.math
scoreboard players operation $vector.dot_product.v.1 bs.in = #BY meccha.math
scoreboard players operation $vector.dot_product.v.2 bs.in = #BZ meccha.math
function #bs.vector:dot_product {scaling:1000}
scoreboard players operation #DOT meccha.math = $vector.dot_product bs.out
