# meccha:eyedropper/match_case_step
# Pop cases[0], decide if it matches the live block properties; if so, bake
# its model's geometry onto the combined face list.
data modify storage meccha:rt cur_case set from storage meccha:rt cases[0]
data remove storage meccha:rt cases[0]

data modify storage meccha:rt match set value 0b
# Empty tests => unconditional (default variant / multipart "always" case).
execute if data storage meccha:rt cur_case{tests:[]} run data modify storage meccha:rt match set value 1b
execute unless data storage meccha:rt cur_case{tests:[]} run function meccha:eyedropper/test_subsets

execute if data storage meccha:rt {match:1b} run function meccha:eyedropper/apply_case
# Variants: exactly one variant applies - stop after the first match.
execute if data storage meccha:rt {match:1b,mmode:"first"} run return 0

# Keep scanning remaining cases (multipart accumulates every match).
function meccha:eyedropper/match_case
