# meccha:eyedropper/on_block_entry
# PILLAR 4.1 - Bookshelf block-hit callback. Runs AT the hit block.
#   Step 1 (done): Bookshelf found this solid block.
#   Step 2: read its exact state, resolve the model -> shape geometry.
#   Step 3: secondary virtual raycast against that geometry -> uv -> hex.

function meccha:lib/block/get_block
# say eyedropper hit block

# Fresh sample record. best_t huge so the first valid face wins.
data modify storage meccha:rt sample set value {model:"",found:0b}
scoreboard players set #BEST_T meccha.math 2000000000

# --- Step 2: state -> model -> shape geometry ---
function meccha:eyedropper/resolve_state with storage meccha:rt block
execute if data storage meccha:rt {sample:{model:""}} run return run function meccha:eyedropper/no_sample
function meccha:eyedropper/load_shape with storage meccha:rt sample

# --- Step 3: virtual raycast over the shape's faces ---
# Block min corner B from the raycast lambda (integer block coords), *1000.
scoreboard players operation #BX meccha.math = $raycast.targeted_block.x bs.lambda
scoreboard players operation #BY meccha.math = $raycast.targeted_block.y bs.lambda
scoreboard players operation #BZ meccha.math = $raycast.targeted_block.z bs.lambda
scoreboard players operation #BX meccha.math *= #SCALE meccha.math
scoreboard players operation #BY meccha.math *= #SCALE meccha.math
scoreboard players operation #BZ meccha.math *= #SCALE meccha.math

# Block-local ray origin O' = O - B  (keeps fixed-point in range).
execute store result score #OX meccha.math run data get storage meccha:rt ray.ox 1000
execute store result score #OY meccha.math run data get storage meccha:rt ray.oy 1000
execute store result score #OZ meccha.math run data get storage meccha:rt ray.oz 1000

# tellraw @a [{"text":"O=("},{"score":{"name":"#OX","objective":"meccha.math"}},{"text":","},{"score":{"name":"#OY","objective":"meccha.math"}},{"text":","},{"score":{"name":"#OZ","objective":"meccha.math"}},{"text":")"}]

scoreboard players operation #OX meccha.math -= #BX meccha.math
scoreboard players operation #OY meccha.math -= #BY meccha.math
scoreboard players operation #OZ meccha.math -= #BZ meccha.math
# Ray direction D (already block-scaled, |D|~1).
execute store result score #DX meccha.math run data get storage meccha:rt ray.dx 1000
execute store result score #DY meccha.math run data get storage meccha:rt ray.dy 1000
execute store result score #DZ meccha.math run data get storage meccha:rt ray.dz 1000

# tellraw @a [{"text":"O'=("},{"score":{"name":"#OX","objective":"meccha.math"}},{"text":","},{"score":{"name":"#OY","objective":"meccha.math"}},{"text":","},{"score":{"name":"#OZ","objective":"meccha.math"}},{"text":") B=("},{"score":{"name":"#BX","objective":"meccha.math"}},{"text":","},{"score":{"name":"#BY","objective":"meccha.math"}},{"text":","},{"score":{"name":"#BZ","objective":"meccha.math"}},{"text":") D=("},{"score":{"name":"#DX","objective":"meccha.math"}},{"text":","},{"score":{"name":"#DY","objective":"meccha.math"}},{"text":","},{"score":{"name":"#DZ","objective":"meccha.math"}},{"text":")"}]

function meccha:eyedropper/raycast_faces
execute if data storage meccha:rt {sample:{found:1b}} run return run function meccha:eyedropper/finalize
execute unless data storage meccha:rt {sample:{found:1b}} run return run function meccha:eyedropper/no_sample
