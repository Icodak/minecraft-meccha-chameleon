# meccha:eyedropper/feedback   (macro: $(rgb) "#RRGGBB", $(color) "#RRGGBBAA")
$title @s actionbar [{"text":"\u2588 ","color":"$(rgb)"},{"text":"Sampled $(color)","color":"white"}]
playsound minecraft:block.note_block.pling player @s ~ ~ ~ 0.6 1.6
