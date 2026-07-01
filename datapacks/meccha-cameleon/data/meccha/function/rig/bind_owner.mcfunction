# meccha:rig/bind_owner   (macro: $(rid) \u2014 executed AS the owning player)
# Mark the rig as owned + following, and stamp the owner's UUID on the root for
# reverse lookup / bookkeeping.
$tag @e[tag=meccha_rig_root,tag=r$(rid),limit=1] add rig_follow
$data modify entity @e[tag=meccha_rig_root,tag=r$(rid),limit=1] data.owner set from entity @s UUID
