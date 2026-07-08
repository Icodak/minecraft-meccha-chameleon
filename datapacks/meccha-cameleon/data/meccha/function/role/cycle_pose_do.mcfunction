# meccha:role/cycle_pose_do   (macro: $(rid))
# Read the bound rig's current pose, pick the next one, and apply it to that rig.
$data modify storage meccha:rt cyc.cur set from entity @e[tag=meccha_rig_root,tag=r$(rid),limit=1] data.pose
data modify storage meccha:rt cyc.pose set value "standing"
execute if data storage meccha:rt cyc{cur:"standing"} run data modify storage meccha:rt cyc.pose set value "crawling"
execute if data storage meccha:rt cyc{cur:"crawling"} run data modify storage meccha:rt cyc.pose set value "superhero_landing"
execute if data storage meccha:rt cyc{cur:"superhero_landing"} run data modify storage meccha:rt cyc.pose set value "sneaking"
execute if data storage meccha:rt cyc{cur:"sneaking"} run data modify storage meccha:rt cyc.pose set value "creeper"
execute if data storage meccha:rt cyc{cur:"creeper"} run data modify storage meccha:rt cyc.pose set value "zombie"
execute if data storage meccha:rt cyc{cur:"zombie"} run data modify storage meccha:rt cyc.pose set value "t_pose"
execute if data storage meccha:rt cyc{cur:"t_pose"} run data modify storage meccha:rt cyc.pose set value "standing"
function meccha:rig/pose_set with storage meccha:rt cyc
