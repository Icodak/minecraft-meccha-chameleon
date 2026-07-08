# meccha:rig/poses/standing_apply   (macro: $(rid); positioned at the rig root)
# The file in /pose is the source of truth for the pose, call generate_rotations.bat/.sh to regenerate the rotated versions
$function meccha:rig/apply_pose {cuboid:"head", dx:-0.125,  dy:0.75,  dz:-0.015, yaw:0, pitch:0, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"torso",dx:-0.125,  dy:0.375, dz:0.0, yaw:0, pitch:0, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"arm_l",dx:0.125, dy:0.375, dz:0.0, yaw:0, pitch:0, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"arm_r",dx:-0.25,dy:0.375, dz:0.0, yaw:0, pitch:0, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"leg_l",dx:0.01, dy:0.0,  dz:0.0, yaw:0, pitch:0, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"leg_r",dx:-0.135,dy:0.0,  dz:0.0, yaw:0, pitch:0, rid:$(rid)}
