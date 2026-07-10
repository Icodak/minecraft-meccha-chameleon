# meccha:eyedropper/feedback   (macro: $(rgb) "#RRGGBB", $(color) "#RRGGBBAA")
# say feedback?
$title @s actionbar [{text:"█ ",color:"$(rgb)"},{text:"Sampled $(color)",color:"white"}]
playsound minecraft:entity.chicken.egg player @s ~ ~ ~ 0.6 1.6
