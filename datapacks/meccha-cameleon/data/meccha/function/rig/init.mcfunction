# meccha:rig/init
# Spawn a NEW rig at the caller's position and give it a unique rig id (rid).
# Every entity of the rig is tagged r<rid>; markers store data.rid. The rid is
# left in storage meccha:rt newrig.rid so callers (e.g. rig/spawn_for) can bind.
scoreboard players add #RIG_NEXT meccha.sys 1
data modify storage meccha:rt newrig set value {pose:"standing", direction:"south"}
execute store result storage meccha:rt newrig.rid int 1 run scoreboard players get #RIG_NEXT meccha.sys

# Root marker (unassigned until assign_rid stamps the rid).
summon minecraft:marker ~ ~ ~ {Tags:["meccha_rig_root","meccha_rig_part","rig_unassigned","hider"],data:{fat:{c:[0.0d,1.0d,0.0d],h:[0.6d,1.2d,0.6d]},pose:"standing"}}
function meccha:rig/spawn
function meccha:rig/assign_rid with storage meccha:rt newrig

# Pose + BVH sync, scoped to the new rig.
function meccha:rig/pose_set with storage meccha:rt newrig
function meccha:rig/sync_rig with storage meccha:rt newrig
