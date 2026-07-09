title @s actionbar [{text:"Directional shadows: "},{text:"Disabled",color:"red"}]
tag @s remove paint_with_automatic_directional_shadow
playsound minecraft:block.sniffer_egg.plop master @s ~ ~ ~ 1 0


item replace entity @s weapon.mainhand with minecraft:knowledge_book[minecraft:recipes=["meccha:directional_shadows"],minecraft:item_name=[{"text":"Directional shadows","color":"yellow"}],item_model=carved_pumpkin]