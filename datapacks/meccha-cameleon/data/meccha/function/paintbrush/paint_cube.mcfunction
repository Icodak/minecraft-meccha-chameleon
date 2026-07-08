# meccha:paintbrush/paint_cube   (macro: $(rid) $(cuboid) $(color) $(shadow))
# Brush type "cube" — recolour every pixel on every face of this cuboid.
$execute as @e[type=text_display,tag=meccha_pixel,tag=r$(rid),tag=cb_$(cuboid)] run function meccha:paintbrush/apply_color {color:"$(color)",shadow:$(shadow)}