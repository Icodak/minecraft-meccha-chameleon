# meccha:eyedropper/match_case
# Walk every case. Variants stop at the first match (decided in the step);
# multipart keeps going so all matching parts stack into `faces`.
execute if data storage meccha:rt cases[0] run function meccha:eyedropper/match_case_step
