# meccha:rig/poses/creeper_apply_west   (macro: $(rid); positioned at the rig root)
# The file in /pose is the source of truth for the pose, call generate_rotations.bat/.sh to regenerate the rotated versions
$function meccha:rig/apply_pose {cuboid:"head", dx:0.0625, dy:0.625, dz:-0.125, yaw:90, pitch:0, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"torso", dx:0, dy:0.25, dz:-0.125, yaw:90, pitch:0, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"arm_l", dx:0.125, dy:0, dz:0.085, yaw:115, pitch:0, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"arm_r", dx:0.075, dy:0, dz:-0.185, yaw:65, pitch:0, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"leg_l", dx:-0.125, dy:0, dz:0.02, yaw:65, pitch:0, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"leg_r", dx:-0.05, dy:0, dz:-0.13, yaw:115, pitch:0, rid:$(rid)}
