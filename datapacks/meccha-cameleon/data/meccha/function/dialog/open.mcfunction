# meccha:dialog/open   (op helper)
# Open the colour picker for the executing player. Non-ops can also open it from
# the pause menu / Quick Actions key (see the dialog tags). Enable the triggers
# so the first click registers immediately.
scoreboard players enable @s meccha.pick_rgb
scoreboard players enable @s meccha.pick_adj
dialog show @s meccha:color_picker
