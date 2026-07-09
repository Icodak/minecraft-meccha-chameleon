# meccha:role/pose_used   (executed AS a player)
# A knowledge book was right-clicked this tick (and consumed). Reset the
# counter; if the player is a hider, cycle the rig pose and re-give the book.
# (Only hiders carry the Pose Switcher, so a stray knowledge book from another
#  player simply does nothing here besides being re-gifted.)
function meccha:role/cycle_pose