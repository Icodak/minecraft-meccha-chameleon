# meccha:eyedropper/select_apply
# Resolve one case's apply list into a single model id (sel.model).
#   * single object -> that model.
#   * weighted array -> position-stable random pick (matches vanilla's
#     per-position model choice as closely as we can without its RNG).
data modify storage meccha:rt sel.model set value ""
execute if data storage meccha:rt sel.apply[1] run function meccha:eyedropper/select_apply_weighted
execute unless data storage meccha:rt sel.apply[1] run data modify storage meccha:rt sel.model set from storage meccha:rt sel.apply[0].model
