# meccha:paintbrush/apply_color   (executed AS the target pixel)
# $say painting $(color) $(shadow)

$execute if score #FALSE meccha.math matches $(shadow) run data modify entity @s text.color set value "$(color)"
$execute if score #TRUE meccha.math matches $(shadow) run function meccha:paintbrush/directional_shading/apply_color_shadowed {color:"$(color)"}
