# meccha:lib/raycast/run_block
# Real Bookshelf raycast API: a function macro `#bs.raycast:run {with:{...}}`
# whose callbacks are inline command strings (NOT function tags). Run this from
# the eye position + rotation (the eyedropper calls it via `at @s anchored
# eyes`). `on_targeted_block` runs `at` the aligned hit block.
# `return run` forwards Bookshelf's hit/miss result (1/0) to our caller.
return run function #bs.raycast:run {with:{max_distance:6.0,on_targeted_block:"function meccha:eyedropper/on_block_entry"}}
