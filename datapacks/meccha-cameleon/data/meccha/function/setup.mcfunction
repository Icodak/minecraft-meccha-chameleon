# meccha:setup
# One-call onboarding for a developer/tester:
#   - hand over the three tools + pose switcher
#   - spawn a demo hider rig BOUND to you (follows you; poseable)
say [Meccha] Setting you up...
function meccha:give/tools
function meccha:give/pose_switcher
function meccha:rig/spawn_for
tellraw @s [{"text":"[Meccha] ","color":"green"},{"text":"Tools given + a rig bound to you. ","color":"gray"},{"text":"Right-hold a tool; right-click the Pose Switcher to change stance.","color":"yellow"}]
