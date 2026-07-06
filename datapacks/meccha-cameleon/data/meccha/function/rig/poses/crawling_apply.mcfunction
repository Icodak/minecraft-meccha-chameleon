# meccha:rig/poses/crawling_apply   (macro: $(rid); positioned at the rig root)
# Body dropped and pitched forward 90 deg; limbs splayed for a prone crawl.
$function meccha:rig/apply_pose {cuboid:"head", dx:-0.125,  dy:0.27, dz:0.3625, yaw:0, pitch:80, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"torso",dx:-0.125,  dy:0.125, dz:0.0,  yaw:0, pitch:90, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"arm_l",dx:0.125, dy:0.125, dz:0.40, yaw:-40, pitch:90, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"arm_r",dx:-0.2,dy:0.125, dz:0.25, yaw:40, pitch:90, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"leg_l",dx:0.0625, dy:0.125, dz:-0.3625,yaw:10, pitch:90, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"leg_r",dx:-0.1875,dy:0.125, dz:-0.34,yaw:-10, pitch:90, rid:$(rid)}
