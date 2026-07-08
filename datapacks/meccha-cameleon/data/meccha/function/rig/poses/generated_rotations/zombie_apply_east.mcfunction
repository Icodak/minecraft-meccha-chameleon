# meccha:rig/poses/zombie_apply_east   (macro: $(rid); positioned at the rig root)
# The file in /pose is the source of truth for the pose, call generate_rotations.bat/.sh to regenerate the rotated versions
$function meccha:rig/apply_pose {cuboid:"head", dx:-0.015, dy:0.75, dz:0.125, yaw:-95, pitch:7, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"torso", dx:0, dy:0.375, dz:0.125, yaw:-90, pitch:0, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"arm_l", dx:0, dy:0.725, dz:-0.125, yaw:-90, pitch:90, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"arm_r", dx:0, dy:0.725, dz:0.25, yaw:-90, pitch:90, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"leg_l", dx:0, dy:0, dz:-0.01, yaw:-90, pitch:0, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"leg_r", dx:0, dy:0, dz:0.135, yaw:-90, pitch:0, rid:$(rid)}
