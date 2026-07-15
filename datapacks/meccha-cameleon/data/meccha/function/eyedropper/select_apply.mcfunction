# meccha:eyedropper/select_apply
# Resolve one blockstate apply entry into the final model.
execute if data storage meccha:rt sample.apply[1] run function meccha:eyedropper/select_apply_weighted
execute unless data storage meccha:rt sample.apply[1] run data modify storage meccha:rt sample.model set from storage meccha:rt sample.apply[0].model
