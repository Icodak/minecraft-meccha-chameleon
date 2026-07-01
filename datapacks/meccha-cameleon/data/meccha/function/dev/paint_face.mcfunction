# meccha:dev/paint_face   (macro: $(rid) $(cuboid) $(face) $(color))
# Recolour every pixel of one face — handy for orientation/UV checks.
$data modify storage meccha:rt col.hex set value "$(color)"
function meccha:lib/color/hex_to_argb
$execute as @e[type=text_display,tag=meccha_pixel,tag=r$(rid),tag=cb_$(cuboid),tag=face_$(face)] run function meccha:paintbrush/apply_color
