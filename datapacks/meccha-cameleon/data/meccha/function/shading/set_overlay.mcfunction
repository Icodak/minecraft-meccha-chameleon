# meccha:shading/set_overlay   (macro: $(opacity), run as the overlay entity)
# Color is a plain RGB hex string on the text component; opacity is the
# separate signed-byte `text_opacity` field. These were previously conflated
# into one packed ARGB int, which isn't how text_display coloring works.
data modify entity @s text.color set value "#000000"
$data modify entity @s text_opacity set value $(opacity)