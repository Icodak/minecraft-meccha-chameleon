# meccha:rig/despawn   (macro: $(rid))
# Remove every entity of rig <rid> and its BVH storage entry.
$kill @e[tag=r$(rid),tag=meccha_rig_part]
$data remove storage meccha:players r$(rid)
