# meccha:dev/show_bvh   (run directly; draws once)
# Visualise the Pillar-7 BVH:
#   * Fat AABB (broad phase): 8 end_rod corners around each rig root.
#     Offsets mirror rig/init's fat = { c:[0,1,0], h:[0.6,1.2,0.6] }.
#   * Limb OBBs (narrow phase): per-cuboid rotated axes (dev/show_axes).
execute as @e[tag=meccha_rig_root] at @s positioned ~ ~1 ~ run function meccha:dev/bvh_corners
function meccha:dev/show_axes
tellraw @s [{"text":"[dev] ","color":"green"},{"text":"BVH drawn (red box = Fat AABB, axes = limb OBBs).","color":"gray"}]
