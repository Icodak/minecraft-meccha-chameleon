# meccha:eyedropper/cast
# PILLAR 4.1 Step 1 — capture the world-space look ray, then run Bookshelf's
# block raycast. Executed: at <player> anchored eyes.
# capture_ray fills #OX..#DZ scores + meccha:rt ray.* (used by the secondary
# virtual raycast in Step 3) and is multiplayer-robust.
function meccha:lib/uuid/store_current_uuid_as_string with entity @s
function meccha:lib/raycast/capture_ray

# Step 1: hand off to Bookshelf to find the first solid block. Its
# on_targeted_block callback runs meccha:eyedropper/on_block_entry. The return
# value is 1 on a block hit, 0 on a full miss.
data modify storage meccha:rt sample set value {found:0b}
execute store result score #RC meccha.tmp run function meccha:lib/raycast/run_block
execute if score #RC meccha.tmp matches 0 run function meccha:eyedropper/no_sample