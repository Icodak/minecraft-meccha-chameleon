# meccha:shading/apply_overlay   (macro: $(rid) rig, $(id) cuboid, $(dir) face, $(argb))
$execute as @e[type=text_display,tag=meccha_overlay,tag=r$(rid),tag=cb_$(id),tag=face_$(dir),limit=1] run function meccha:shading/set_overlay with storage meccha:rt sh
