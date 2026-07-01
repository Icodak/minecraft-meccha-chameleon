# meccha:eyedropper/test_subsets_loop
data modify storage meccha:rt cur_test set from storage meccha:rt tests[0]
data remove storage meccha:rt tests[0]
function meccha:eyedropper/test_one with storage meccha:rt
execute if data storage meccha:rt {match:0b} if data storage meccha:rt tests[0] run function meccha:eyedropper/test_subsets_loop
