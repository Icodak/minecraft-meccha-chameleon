# meccha:shading/apply_overlay   (macro: $(id) cuboid, $(dir) face, $(opacity))
$execute as @e[type=text_display,tag=meccha_overlay,tag=cb_$(id),tag=face_$(dir),limit=1] run function meccha:shading/set_overlay with storage meccha:rt sh
