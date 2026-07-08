# meccha:rig/poses/superhero_landing_apply_north   (macro: $(rid); positioned at the rig root)
# The file in /pose is the source of truth for the pose, call generate_rotations.bat/.sh to regenerate the rotated versions
$function meccha:rig/apply_pose {cuboid:"head", dx:0, dy:0.4, dz:-0.1, yaw:-180, pitch:45, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"torso", dx:0, dy:0.2, dz:0.25, yaw:-180, pitch:60, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"arm_l", dx:-0.3, dy:0, dz:-0.1, yaw:-100, pitch:0, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"arm_r", dx:0.1, dy:0.3, dz:-0.1, yaw:150, pitch:-60, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"leg_l", dx:-0.125, dy:0, dz:0.15, yaw:-180, pitch:-90, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"leg_r", dx:0.125, dy:0.001, dz:-0.05, yaw:-180, pitch:-40, rid:$(rid)}
