# meccha:rig/apply_current   (executed AS a rig root, at @s)
# Read this rig's id + current pose and dispatch to the matching pose-apply,
# scoped to this rig only. Runs positioned at the root so apply_pose's relative
# offsets land correctly.
data modify storage meccha:rt cur set value {rid:0,pose:""}
data modify storage meccha:rt cur.rid set from entity @s data.rid
data modify storage meccha:rt cur.pose set from entity @s data.pose
$execute if data storage meccha:rt cur{pose:"standing"} run function meccha:rig/poses/generated_rotations/standing_apply_$(direction) with storage meccha:rt cur
$execute if data storage meccha:rt cur{pose:"crawling"} run function meccha:rig/poses/generated_rotations/crawling_apply_$(direction) with storage meccha:rt cur
$execute if data storage meccha:rt cur{pose:"superhero_landing"} run function meccha:rig/poses/generated_rotations/superhero_landing_apply_$(direction) with storage meccha:rt cur
$execute if data storage meccha:rt cur{pose:"sneaking"} run function meccha:rig/poses/generated_rotations/sneaking_apply_$(direction) with storage meccha:rt cur
$execute if data storage meccha:rt cur{pose:"creeper"} run function meccha:rig/poses/generated_rotations/creeper_apply_$(direction) with storage meccha:rt cur
$execute if data storage meccha:rt cur{pose:"t_pose"} run function meccha:rig/poses/generated_rotations/t_pose_apply_$(direction) with storage meccha:rt cur
$execute if data storage meccha:rt cur{pose:"zombie"} run function meccha:rig/poses/generated_rotations/zombie_apply_$(direction) with storage meccha:rt cur
