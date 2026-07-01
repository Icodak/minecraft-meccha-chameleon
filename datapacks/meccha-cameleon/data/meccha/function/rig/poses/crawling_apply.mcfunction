# meccha:rig/poses/crawling_apply   (macro: $(rid); positioned at the rig root)
# Body dropped and pitched forward 90 deg; limbs splayed for a prone crawl.
$function meccha:rig/apply_pose {cuboid:"head", dx:0.0,  dy:0.45, dz:0.55, yaw:0, pitch:90, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"torso",dx:0.0,  dy:0.30, dz:0.0,  yaw:0, pitch:90, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"arm_l",dx:0.375, dy:0.30, dz:0.40, yaw:0, pitch:90, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"arm_r",dx:-0.375,dy:0.30, dz:0.40, yaw:0, pitch:90, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"leg_l",dx:0.125, dy:0.30, dz:-0.45,yaw:0, pitch:90, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"leg_r",dx:-0.125,dy:0.30, dz:-0.45,yaw:0, pitch:90, rid:$(rid)}
