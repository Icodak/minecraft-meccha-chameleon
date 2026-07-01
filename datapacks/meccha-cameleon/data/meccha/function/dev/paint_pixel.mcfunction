# meccha:dev/paint_pixel   (macro: $(rid) $(cuboid) $(face) $(u) $(v) $(color))
# Directly recolour one pixel by its tags (tests Paintbrush pixel addressing).
$data modify storage meccha:rt col.hex set value "$(color)"
function meccha:lib/color/hex_to_argb
$execute as @e[type=text_display,tag=meccha_pixel,tag=r$(rid),tag=cb_$(cuboid),tag=face_$(face),tag=u_$(u),tag=v_$(v)] run function meccha:paintbrush/apply_color
