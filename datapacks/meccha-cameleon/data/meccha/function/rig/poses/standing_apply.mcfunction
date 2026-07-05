# meccha:rig/poses/standing_apply   (macro: $(rid); positioned at the rig root)
# Neutral upright stack: cuboids at their rest offsets, no rotation.
$function meccha:rig/apply_pose {cuboid:"head", dx:-0.125,  dy:0.75,  dz:-0.015, yaw:0, pitch:0, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"torso",dx:-0.125,  dy:0.375, dz:0.0, yaw:0, pitch:0, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"arm_l",dx:0.38, dy:0.375, dz:0.14, yaw:-90, pitch:-45, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"arm_r",dx:-0.38,dy:0.375, dz:0.015, yaw:90, pitch:-45, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"leg_l",dx:0.01, dy:0.0,  dz:-0.015, yaw:0, pitch:0, rid:$(rid)}
$function meccha:rig/apply_pose {cuboid:"leg_r",dx:-0.135,dy:0.0,  dz:-0.015, yaw:0, pitch:0, rid:$(rid)}
