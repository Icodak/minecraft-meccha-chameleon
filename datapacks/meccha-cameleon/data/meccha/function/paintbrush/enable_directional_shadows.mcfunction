title @s actionbar [{text:"Directional shadows: "},{text:"Enabled",color:"green"}]
tag @s add paint_with_automatic_directional_shadow
playsound minecraft:block.sniffer_egg.plop master @s ~ ~ ~ 1 2

item replace entity @s weapon.mainhand with minecraft:knowledge_book[minecraft:recipes=["meccha:directional_shadows"],minecraft:item_name=[{"text":"Directional shadows","color":"yellow"}],item_model=jack_o_lantern]