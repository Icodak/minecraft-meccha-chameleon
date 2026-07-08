# meccha:rig/poses/sneaking_apply_east   (macro: $(rid); positioned at the rig root)
# The file in /pose is the source of truth for the pose, call generate_rotations.bat/.sh to regenerate the rotated versions
$function meccha:rig/apply_pose {cuboid:"head", dx:-0.065, dy:0.7, dz:0.125, yaw:-90, pitch:20, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"torso", dx:-0.2, dy:0.375, dz:0.125, yaw:-90, pitch:30, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"arm_l", dx:-0.2, dy:0.375, dz:-0.175, yaw:-75, pitch:30, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"arm_r", dx:-0.2, dy:0.375, dz:0.3, yaw:-105, pitch:30, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"leg_l", dx:-0.2, dy:0, dz:-0.01, yaw:-90, pitch:0, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"leg_r", dx:-0.2, dy:0, dz:0.135, yaw:-90, pitch:0, rid:$(rid)}
