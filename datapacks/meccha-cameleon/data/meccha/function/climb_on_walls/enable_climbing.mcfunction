execute as @a[tag=meccha_hider] at @s run fill ~1 ~1 ~1 ~-1 ~-1 ~-1 air replace minecraft:structure_void
execute as @a[tag=meccha_hider] at @s unless block ~0.4 ~ ~ #air run fill ~ ~ ~ ~ ~ ~ structure_void replace air
execute as @a[tag=meccha_hider] at @s unless block ~-0.4 ~ ~ #air run fill ~ ~ ~ ~ ~ ~ structure_void replace air
execute as @a[tag=meccha_hider] at @s unless block ~ ~ ~0.4 #air run fill ~ ~ ~ ~ ~ ~ structure_void replace air
execute as @a[tag=meccha_hider] at @s unless block ~ ~ ~-0.4 #air run fill ~ ~ ~ ~ ~ ~ structure_void replace air