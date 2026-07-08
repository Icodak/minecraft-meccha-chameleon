# meccha:paintbrush/test_cuboid   (executed `as` a cuboid marker)
# Load this cuboid's world-space face list (rebuilt on every pose update, see
# Pillar 5/6) and ray-test each face. Faces (n, p0, eu, ev) are stored in the
# cuboid's own LOCAL (unrotated) frame, relative to the marker's origin - so
# the ray must be rotated into that frame too, same OBB-style axis transform
# used in meccha:hunter/test_obb (Pillar 7.3).
data modify storage meccha:rt cb set from entity @s data
data modify storage meccha:rt cb_id set from entity @s data.cuboid
data modify storage meccha:rt cb_rid set from entity @s data.rid
data modify storage meccha:rt wfaces set from entity @s data.wfaces

# --- pose trig for this cuboid (yaw/pitch, same convention as test_obb) ---
scoreboard players set #C360 meccha.tmp 360
execute store result score #DYAW meccha.tmp run data get entity @s Rotation[0] 1
execute store result score #DPITCH meccha.tmp run data get entity @s Rotation[1] 1
scoreboard players operation #DYAW meccha.tmp *= #NEGATIVE_ONE meccha.math
scoreboard players operation #DYAW meccha.tmp %= #C360 meccha.tmp
scoreboard players operation #DPITCH meccha.tmp %= #C360 meccha.tmp
execute store result storage meccha:rt sh.yaw int 1 run scoreboard players get #DYAW meccha.tmp
execute store result storage meccha:rt sh.pitch int 1 run scoreboard players get #DPITCH meccha.tmp
function meccha:lib/math/load_trig with storage meccha:rt sh

# --- u = R * X_local, v = R * Y_local, w = u x v (cuboid's local axes, in
# world space) ---
scoreboard players set #NLX meccha.math 1000
scoreboard players set #NLY meccha.math 0
scoreboard players set #NLZ meccha.math 0
function meccha:lib/math/rot_normal
scoreboard players operation #UX meccha.math = #WNX meccha.math
scoreboard players operation #UY meccha.math = #WNY meccha.math
scoreboard players operation #UZ meccha.math = #WNZ meccha.math
scoreboard players set #NLX meccha.math 0
scoreboard players set #NLY meccha.math 1000
scoreboard players set #NLZ meccha.math 0
function meccha:lib/math/rot_normal
scoreboard players operation #VX meccha.math = #WNX meccha.math
scoreboard players operation #VY meccha.math = #WNY meccha.math
scoreboard players operation #VZ meccha.math = #WNZ meccha.math
scoreboard players operation #AX meccha.math = #UX meccha.math
scoreboard players operation #AY meccha.math = #UY meccha.math
scoreboard players operation #AZ meccha.math = #UZ meccha.math
scoreboard players operation #BX meccha.math = #VX meccha.math
scoreboard players operation #BY meccha.math = #VY meccha.math
scoreboard players operation #BZ meccha.math = #VZ meccha.math
function meccha:lib/vector/cross_product
scoreboard players operation #WX meccha.math = #CRX meccha.math
scoreboard players operation #WY meccha.math = #CRY meccha.math
scoreboard players operation #WZ meccha.math = #CRZ meccha.math

# --- p = O - cuboidOrigin (world-space offset from the box's origin) ---
execute store result score #BX meccha.math run data get entity @s Pos[0] 1000
execute store result score #BY meccha.math run data get entity @s Pos[1] 1000
execute store result score #BZ meccha.math run data get entity @s Pos[2] 1000
scoreboard players operation #PX0 meccha.math = #OX meccha.math
scoreboard players operation #PY0 meccha.math = #OY meccha.math
scoreboard players operation #PZ0 meccha.math = #OZ meccha.math
scoreboard players operation #PX0 meccha.math -= #BX meccha.math
scoreboard players operation #PY0 meccha.math -= #BY meccha.math
scoreboard players operation #PZ0 meccha.math -= #BZ meccha.math

# --- local ray origin O' = p . (u,v,w): projects the world offset into the
# cuboid's own unrotated frame, which is the frame the wfaces are stored in.
scoreboard players operation #AX meccha.math = #PX0 meccha.math
scoreboard players operation #AY meccha.math = #PY0 meccha.math
scoreboard players operation #AZ meccha.math = #PZ0 meccha.math
scoreboard players operation #BX meccha.math = #UX meccha.math
scoreboard players operation #BY meccha.math = #UY meccha.math
scoreboard players operation #BZ meccha.math = #UZ meccha.math
function meccha:lib/math/dot3
scoreboard players operation #OLX meccha.math = #DOT meccha.math
scoreboard players operation #AX meccha.math = #PX0 meccha.math
scoreboard players operation #AY meccha.math = #PY0 meccha.math
scoreboard players operation #AZ meccha.math = #PZ0 meccha.math
scoreboard players operation #BX meccha.math = #VX meccha.math
scoreboard players operation #BY meccha.math = #VY meccha.math
scoreboard players operation #BZ meccha.math = #VZ meccha.math
function meccha:lib/math/dot3
scoreboard players operation #OLY meccha.math = #DOT meccha.math
scoreboard players operation #AX meccha.math = #PX0 meccha.math
scoreboard players operation #AY meccha.math = #PY0 meccha.math
scoreboard players operation #AZ meccha.math = #PZ0 meccha.math
scoreboard players operation #BX meccha.math = #WX meccha.math
scoreboard players operation #BY meccha.math = #WY meccha.math
scoreboard players operation #BZ meccha.math = #WZ meccha.math
function meccha:lib/math/dot3
scoreboard players operation #OLZ meccha.math = #DOT meccha.math

# --- local ray direction D' = D . (u,v,w): the same rotation applied to the
# ray direction so it lines up with the face normals/edges stored locally.
scoreboard players operation #AX meccha.math = #DX meccha.math
scoreboard players operation #AY meccha.math = #DY meccha.math
scoreboard players operation #AZ meccha.math = #DZ meccha.math
scoreboard players operation #BX meccha.math = #UX meccha.math
scoreboard players operation #BY meccha.math = #UY meccha.math
scoreboard players operation #BZ meccha.math = #UZ meccha.math
function meccha:lib/math/dot3
scoreboard players operation #DLX meccha.math = #DOT meccha.math
scoreboard players operation #AX meccha.math = #DX meccha.math
scoreboard players operation #AY meccha.math = #DY meccha.math
scoreboard players operation #AZ meccha.math = #DZ meccha.math
scoreboard players operation #BX meccha.math = #VX meccha.math
scoreboard players operation #BY meccha.math = #VY meccha.math
scoreboard players operation #BZ meccha.math = #VZ meccha.math
function meccha:lib/math/dot3
scoreboard players operation #DLY meccha.math = #DOT meccha.math
scoreboard players operation #AX meccha.math = #DX meccha.math
scoreboard players operation #AY meccha.math = #DY meccha.math
scoreboard players operation #AZ meccha.math = #DZ meccha.math
scoreboard players operation #BX meccha.math = #WX meccha.math
scoreboard players operation #BY meccha.math = #WY meccha.math
scoreboard players operation #BZ meccha.math = #WZ meccha.math
function meccha:lib/math/dot3
scoreboard players operation #DLZ meccha.math = #DOT meccha.math

function meccha:paintbrush/faces_loop
