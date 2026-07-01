# meccha:eyedropper/test_subsets
# A case matches if the block properties CONTAIN any one of its test subsets.
data modify storage meccha:rt tests set from storage meccha:rt cur_case.tests
function meccha:eyedropper/test_subsets_loop
