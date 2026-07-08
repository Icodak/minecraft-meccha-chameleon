# meccha:rig/poses/crawling_apply_north   (macro: $(rid); positioned at the rig root)
# The file in /pose is the source of truth for the pose, call generate_rotations.bat/.sh to regenerate the rotated versions
$function meccha:rig/apply_pose {cuboid:"head", dx:0.125, dy:0.27, dz:-0.3625, yaw:-180, pitch:80, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"torso", dx:0.125, dy:0.125, dz:0, yaw:-180, pitch:90, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"arm_l", dx:-0.125, dy:0.125, dz:-0.4, yaw:140, pitch:90, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"arm_r", dx:0.2, dy:0.125, dz:-0.25, yaw:-140, pitch:90, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"leg_l", dx:-0.0625, dy:0.125, dz:0.3625, yaw:-170, pitch:90, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"leg_r", dx:0.1875, dy:0.125, dz:0.34, yaw:170, pitch:90, rid:$(rid)}
