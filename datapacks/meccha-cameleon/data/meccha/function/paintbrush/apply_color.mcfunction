# meccha:paintbrush/apply_color   (executed AS the target pixel)
# Write the packed ARGB into the text_display background.
execute store result entity @s background int 1 run scoreboard players get #ARGB meccha.math
