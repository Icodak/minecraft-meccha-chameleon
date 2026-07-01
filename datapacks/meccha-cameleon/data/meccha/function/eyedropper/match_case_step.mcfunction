# meccha:eyedropper/match_case_step
# Pop cases[0], decide if it matches the live properties, take its model.
data modify storage meccha:rt cur_case set from storage meccha:rt cases[0]
data remove storage meccha:rt cases[0]

data modify storage meccha:rt match set value 0b
# Empty tests => unconditional (default variant / multipart "always" case).
execute if data storage meccha:rt cur_case{tests:[]} run data modify storage meccha:rt match set value 1b
execute unless data storage meccha:rt cur_case{tests:[]} run function meccha:eyedropper/test_subsets

execute if data storage meccha:rt {match:1b} run data modify storage meccha:rt sample.model set from storage meccha:rt cur_case.apply[0].model

# Continue scanning remaining cases (loop ends when model found or list empty).
function meccha:eyedropper/match_case
