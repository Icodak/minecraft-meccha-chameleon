# meccha:eyedropper/apply_case
# Resolve this case's model (weighted, position-stable) then append its faces
# to the combined accumulator with final texture keys baked in.
data modify storage meccha:rt sel set value {}
data modify storage meccha:rt sel.apply set from storage meccha:rt cur_case.apply
function meccha:eyedropper/select_apply
execute unless data storage meccha:rt {sel:{model:""}} run function meccha:eyedropper/load_part with storage meccha:rt sel
