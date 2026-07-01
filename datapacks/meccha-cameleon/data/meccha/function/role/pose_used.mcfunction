# meccha:role/pose_used   (executed AS a player whose meccha.use_pose >= 1)
# A knowledge book was right-clicked this tick (and consumed). Reset the
# counter; if the player is a hider, cycle the rig pose and re-give the book.
# (Only hiders carry the Pose Switcher, so a stray knowledge book from another
#  player simply does nothing here besides being re-gifted.)
scoreboard players set @s meccha.use_pose 0
function meccha:role/cycle_pose
clear @s minecraft:knowledge_book
function meccha:give/pose_switcher
