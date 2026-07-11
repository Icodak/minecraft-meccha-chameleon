# meccha:hunter/kill_hider $(rid)

$execute as @a[tag=meccha_hider] if score @s meccha.rig matches $(rid) run function meccha:hunter/on_hider_killed
$kill @e[tag=meccha_rig_part,tag=r$(rid)]