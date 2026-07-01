# meccha:hunter/narrow_phase   (executed AS the hider root, at @s)
# PILLAR 7.3 — descend into THIS rig's limb cuboids (scoped by rid so other
# rigs standing nearby are never mixed in) and OBB-test each.
data modify storage meccha:rt nrid set value {rid:0}
data modify storage meccha:rt nrid.rid set from entity @s data.rid
function meccha:hunter/narrow_scan with storage meccha:rt nrid
