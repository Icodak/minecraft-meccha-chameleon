# meccha:shading/set_overlay   (macro: $(argb), run as the overlay entity)
# text.color/text_opacity are pinned invisible at spawn (build_rig.py) and
# never touched again -- only `background` changes per shading refresh.
$data modify entity @s background set value $(argb)