# meccha:eyedropper/match_case
# Recurse over `cases` until a model is chosen (first-match is sufficient for
# colour sampling; the full renderer uses match="all" for multipart).
execute if data storage meccha:rt cases[0] if data storage meccha:rt {sample:{model:""}} run function meccha:eyedropper/match_case_step
