# meccha:paintbrush/paint_pixel   (macro: $(rid) $(cuboid) $(face) $(u) $(v) $(shadow))
# PILLAR 4.2 — target the exact pixel of rig $(rid) via its unique tag tuple.
$execute as @e[type=text_display,tag=meccha_pixel,tag=r$(rid),tag=cb_$(cuboid),tag=face_$(face),tag=u_$(u),tag=v_$(v),limit=1] run function meccha:paintbrush/apply_color {color:"$(color)",shadow:$(shadow)}
