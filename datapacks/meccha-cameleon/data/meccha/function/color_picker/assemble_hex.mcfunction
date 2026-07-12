# meccha:color_picker/assemble_hex   (macro: $(rh) $(gh) $(bh) two-char hex bytes)
# Commit the chosen color as the active brush color (opaque) + feedback.
$data modify storage meccha:rt assembled.rgb set value "#$(rh)$(gh)$(bh)"
$title @s actionbar [{"text":"■ ","color":"#$(rh)$(gh)$(bh)"},{"text":"Color #$(rh)$(gh)$(bh)","color":"white"}]
playsound minecraft:block.note_block.bell player @s ~ ~ ~ 0.5 1.8
