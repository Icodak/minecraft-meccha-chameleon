# meccha:rig/apply_pose   (macro: $(cuboid) $(dx) $(dy) $(dz) $(yaw) $(pitch) $(rid))
# Move ONE cuboid of rig $(rid) to root+offset with the pose rotation. Scoped by
# the r<rid> tag so other rigs are untouched. Stores the world-axis offset on the
# cuboid marker (data.off) so follow can reposition without a full pose dispatch,
# and flags the cuboid so shading recomputes its normals this tick.
# Run positioned at the rig root.
$execute positioned ~$(dx) ~$(dy) ~$(dz) run tp @e[tag=cb_$(cuboid),tag=r$(rid)] ~ ~ ~ $(yaw) $(pitch)
$data modify entity @e[tag=cb_$(cuboid),tag=r$(rid),type=marker,limit=1] data.off set value [$(dx)d,$(dy)d,$(dz)d]
$tag @e[tag=cb_$(cuboid),tag=r$(rid),type=marker] add pose_dirty
