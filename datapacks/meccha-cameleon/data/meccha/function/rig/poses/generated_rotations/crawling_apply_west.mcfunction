# meccha:rig/poses/crawling_apply_west   (macro: $(rid); positioned at the rig root)
# The file in /pose is the source of truth for the pose, call generate_rotations.bat/.sh to regenerate the rotated versions
$function meccha:rig/apply_pose {cuboid:"head", dx:-0.3625, dy:0.27, dz:-0.125, yaw:90, pitch:80, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"torso", dx:0, dy:0.125, dz:-0.125, yaw:90, pitch:90, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"arm_l", dx:-0.4, dy:0.125, dz:0.125, yaw:50, pitch:90, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"arm_r", dx:-0.25, dy:0.125, dz:-0.2, yaw:130, pitch:90, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"leg_l", dx:0.3625, dy:0.125, dz:0.0625, yaw:100, pitch:90, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"leg_r", dx:0.34, dy:0.125, dz:-0.1875, yaw:80, pitch:90, rid:$(rid)}
