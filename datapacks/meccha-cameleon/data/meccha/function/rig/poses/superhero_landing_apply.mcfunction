# meccha:rig/poses/superhero_landing_apply   (macro: $(rid); positioned at the rig root)
# Everything pulled toward a low centre, limbs rotated inward (ball shape).
$function meccha:rig/apply_pose {cuboid:"head", dx:0.0,  dy:0.40, dz:0.10, yaw:0, pitch:45, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"torso",dx:0.0,  dy:0.20, dz:-0.25,  yaw:0, pitch:60, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"arm_l",dx:0.30,  dy:0.0, dz:0.10, yaw:80, pitch:0, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"arm_r",dx:-0.10, dy:0.30, dz:0.10, yaw:-30, pitch:-60, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"leg_l",dx:0.125, dy:0.00, dz:-0.15, yaw:0, pitch:-90, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"leg_r",dx:-0.125,dy:0.001, dz:0.05, yaw:0, pitch:-40, rid:$(rid)}
