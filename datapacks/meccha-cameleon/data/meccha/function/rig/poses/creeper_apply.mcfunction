# meccha:rig/poses/creeper_apply   (macro: $(rid); positioned at the rig root)
# The file in /pose is the source of truth for the pose, call generate_rotations.bat/.sh to regenerate the rotated versions
$function meccha:rig/apply_pose {cuboid:"head", dx:-0.125, dy:0.625, dz:-0.0625, yaw:0, pitch:0, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"torso", dx:-0.125, dy:0.25, dz:0.0, yaw:0, pitch:0, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"arm_l", dx:0.085, dy:0.0, dz:-0.125, yaw:25, pitch:0, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"arm_r", dx:-0.185,dy:0.0, dz:-0.075, yaw:-25, pitch:0, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"leg_l", dx:0.02, dy:0.0, dz:0.125, yaw:-25, pitch:0, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"leg_r", dx:-0.13,dy:0.0, dz:0.05, yaw:25, pitch:0, rid:$(rid)}
