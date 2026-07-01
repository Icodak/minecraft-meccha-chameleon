# meccha:lib/vector/cross_product
# Wrapper over Bookshelf #bs.vector:cross_product (real API).
# IN : #AX/#AY/#AZ (u), #BX/#BY/#BZ (v)  (meccha.math, *1000)
# OUT: #CRX/#CRY/#CRZ = u x v  (meccha.math, *1000)
scoreboard players operation $vector.cross_product.u.0 bs.in = #AX meccha.math
scoreboard players operation $vector.cross_product.u.1 bs.in = #AY meccha.math
scoreboard players operation $vector.cross_product.u.2 bs.in = #AZ meccha.math
scoreboard players operation $vector.cross_product.v.0 bs.in = #BX meccha.math
scoreboard players operation $vector.cross_product.v.1 bs.in = #BY meccha.math
scoreboard players operation $vector.cross_product.v.2 bs.in = #BZ meccha.math
function #bs.vector:cross_product {scaling:1000}
scoreboard players operation #CRX meccha.math = $vector.cross_product.0 bs.out
scoreboard players operation #CRY meccha.math = $vector.cross_product.1 bs.out
scoreboard players operation #CRZ meccha.math = $vector.cross_product.2 bs.out
