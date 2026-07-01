# meccha:dialog/assemble_hex   (macro: $(rh) $(gh) $(bh) two-char hex bytes)
# Commit the chosen colour as the active brush colour (opaque) + feedback.
$data modify storage meccha:rt last_sample set value "#$(rh)$(gh)$(bh)FF"
$title @s actionbar [{"text":"■ ","color":"#$(rh)$(gh)$(bh)"},{"text":"Colour #$(rh)$(gh)$(bh)","color":"white"}]
playsound minecraft:block.note_block.bell player @s ~ ~ ~ 0.5 1.8
