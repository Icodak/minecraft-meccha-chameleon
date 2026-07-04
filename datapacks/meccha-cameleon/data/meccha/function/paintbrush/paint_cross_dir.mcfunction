# meccha:paintbrush/paint_cross_dir   (macro: $(axis) $(score))
# Pulls a neighbour's changed coordinate out of a scoreboard holder into
# cross.<axis>, then paints it. Used for same-face neighbours only.
$execute store result storage meccha:rt cross.$(axis) int 1 run scoreboard players get $(score) meccha.math
function meccha:paintbrush/paint_pixel with storage meccha:rt cross