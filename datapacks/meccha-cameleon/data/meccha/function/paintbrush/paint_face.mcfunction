# meccha:paintbrush/paint_face   (macro: $(rid) $(cuboid) $(face) $(color))
# Brush type "face" — recolour every pixel on this cuboid's face.
$execute as @e[type=text_display,tag=meccha_pixel,tag=r$(rid),tag=cb_$(cuboid),tag=face_$(face)] run function meccha:paintbrush/apply_color {color:"$(color)"}