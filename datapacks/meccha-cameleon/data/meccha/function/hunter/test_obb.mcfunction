# meccha:hunter/test_obb   (executed AS a limb cuboid marker, at @s)
# PILLAR 7.3 \u2014 Oriented Bounding Box test via the Separating Axis Theorem.
# Build the cuboid's rotated axes (u,v,w), then PROJECT the ray onto each axis
# with #bs.vector:dot_product (w itself comes from #bs.vector:cross_product),
# reducing the OBB test to an axis-aligned slab in the box's own frame.

# --- pose trig for this cuboid ---
scoreboard players set #C360 meccha.tmp 360
execute store result score #DYAW meccha.tmp run data get entity @s Rotation[0] 1
execute store result score #DPITCH meccha.tmp run data get entity @s Rotation[1] 1
scoreboard players operation #DYAW meccha.tmp %= #C360 meccha.tmp
scoreboard players operation #DPITCH meccha.tmp %= #C360 meccha.tmp
execute store result storage meccha:rt sh.yaw int 1 run scoreboard players get #DYAW meccha.tmp
execute store result storage meccha:rt sh.pitch int 1 run scoreboard players get #DPITCH meccha.tmp
function meccha:shading/load_trig with storage meccha:rt sh

# --- u = R * X_local ---
scoreboard players set #NLX meccha.math 1000
scoreboard players set #NLY meccha.math 0
scoreboard players set #NLZ meccha.math 0
function meccha:lib/math/rot_normal
scoreboard players operation #UX meccha.math = #WNX meccha.math
scoreboard players operation #UY meccha.math = #WNY meccha.math
scoreboard players operation #UZ meccha.math = #WNZ meccha.math
# --- v = R * Y_local ---
scoreboard players set #NLX meccha.math 0
scoreboard players set #NLY meccha.math 1000
scoreboard players set #NLZ meccha.math 0
function meccha:lib/math/rot_normal
scoreboard players operation #VX meccha.math = #WNX meccha.math
scoreboard players operation #VY meccha.math = #WNY meccha.math
scoreboard players operation #VZ meccha.math = #WNZ meccha.math
# --- w = u x v  (Bookshelf cross product) ---
# --- w = u x v  (Bookshelf cross product) ---
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

# --- half extents + origin, build OBB centre = origin + u*hx + v*hy + w*hz ---
execute store result score #PXc meccha.math run data get entity @s Pos[0] 1000
execute store result score #PYc meccha.math run data get entity @s Pos[1] 1000
execute store result score #PZc meccha.math run data get entity @s Pos[2] 1000
execute store result score #HX meccha.math run data get entity @s data.half[0] 1000
execute store result score #HY meccha.math run data get entity @s data.half[1] 1000
execute store result score #HZ meccha.math run data get entity @s data.half[2] 1000

scoreboard players operation #CWX meccha.math = #PXc meccha.math
scoreboard players operation #A meccha.math = #UX meccha.math
scoreboard players operation #B meccha.math = #HX meccha.math
function meccha:lib/math/mul
scoreboard players operation #CWX meccha.math += #R meccha.math
scoreboard players operation #A meccha.math = #VX meccha.math
scoreboard players operation #B meccha.math = #HY meccha.math
function meccha:lib/math/mul
scoreboard players operation #CWX meccha.math += #R meccha.math
scoreboard players operation #A meccha.math = #WX meccha.math
scoreboard players operation #B meccha.math = #HZ meccha.math
function meccha:lib/math/mul
scoreboard players operation #CWX meccha.math += #R meccha.math

scoreboard players operation #CWY meccha.math = #PYc meccha.math
scoreboard players operation #A meccha.math = #UY meccha.math
scoreboard players operation #B meccha.math = #HX meccha.math
function meccha:lib/math/mul
scoreboard players operation #CWY meccha.math += #R meccha.math
scoreboard players operation #A meccha.math = #VY meccha.math
scoreboard players operation #B meccha.math = #HY meccha.math
function meccha:lib/math/mul
scoreboard players operation #CWY meccha.math += #R meccha.math
scoreboard players operation #A meccha.math = #WY meccha.math
scoreboard players operation #B meccha.math = #HZ meccha.math
function meccha:lib/math/mul
scoreboard players operation #CWY meccha.math += #R meccha.math

scoreboard players operation #CWZ meccha.math = #PZc meccha.math
scoreboard players operation #A meccha.math = #UZ meccha.math
scoreboard players operation #B meccha.math = #HX meccha.math
function meccha:lib/math/mul
scoreboard players operation #CWZ meccha.math += #R meccha.math
scoreboard players operation #A meccha.math = #VZ meccha.math
scoreboard players operation #B meccha.math = #HY meccha.math
function meccha:lib/math/mul
scoreboard players operation #CWZ meccha.math += #R meccha.math
scoreboard players operation #A meccha.math = #WZ meccha.math
scoreboard players operation #B meccha.math = #HZ meccha.math
function meccha:lib/math/mul
scoreboard players operation #CWZ meccha.math += #R meccha.math

# --- p = O - centre ---
scoreboard players operation #PX0 meccha.math = #OX meccha.math
scoreboard players operation #PY0 meccha.math = #OY meccha.math
scoreboard players operation #PZ0 meccha.math = #OZ meccha.math
scoreboard players operation #PX0 meccha.math -= #CWX meccha.math
scoreboard players operation #PY0 meccha.math -= #CWY meccha.math
scoreboard players operation #PZ0 meccha.math -= #CWZ meccha.math

# --- project p and D onto u,v,w via Bookshelf dot products ---
# O_u = p . u
scoreboard players operation #AX meccha.math = #PX0 meccha.math
scoreboard players operation #AY meccha.math = #PY0 meccha.math
scoreboard players operation #AZ meccha.math = #PZ0 meccha.math
scoreboard players operation #BX meccha.math = #UX meccha.math
scoreboard players operation #BY meccha.math = #UY meccha.math
scoreboard players operation #BZ meccha.math = #UZ meccha.math
function meccha:lib/vector/dot_product
scoreboard players operation #OLX meccha.math = #DOT meccha.math
# O_v = p . v
scoreboard players operation #AX meccha.math = #PX0 meccha.math
scoreboard players operation #AY meccha.math = #PY0 meccha.math
scoreboard players operation #AZ meccha.math = #PZ0 meccha.math
scoreboard players operation #BX meccha.math = #VX meccha.math
scoreboard players operation #BY meccha.math = #VY meccha.math
scoreboard players operation #BZ meccha.math = #VZ meccha.math
function meccha:lib/vector/dot_product
scoreboard players operation #OLY meccha.math = #DOT meccha.math
# O_w = p . w
scoreboard players operation #AX meccha.math = #PX0 meccha.math
scoreboard players operation #AY meccha.math = #PY0 meccha.math
scoreboard players operation #AZ meccha.math = #PZ0 meccha.math
scoreboard players operation #BX meccha.math = #WX meccha.math
scoreboard players operation #BY meccha.math = #WY meccha.math
scoreboard players operation #BZ meccha.math = #WZ meccha.math
function meccha:lib/vector/dot_product
scoreboard players operation #OLZ meccha.math = #DOT meccha.math

# D_u = D . u
scoreboard players operation #AX meccha.math = #DX meccha.math
scoreboard players operation #AY meccha.math = #DY meccha.math
scoreboard players operation #AZ meccha.math = #DZ meccha.math
scoreboard players operation #BX meccha.math = #UX meccha.math
scoreboard players operation #BY meccha.math = #UY meccha.math
scoreboard players operation #BZ meccha.math = #UZ meccha.math
function meccha:lib/vector/dot_product
scoreboard players operation #DLX meccha.math = #DOT meccha.math
# D_v = D . v
scoreboard players operation #AX meccha.math = #DX meccha.math
scoreboard players operation #AY meccha.math = #DY meccha.math
scoreboard players operation #AZ meccha.math = #DZ meccha.math
scoreboard players operation #BX meccha.math = #VX meccha.math
scoreboard players operation #BY meccha.math = #VY meccha.math
scoreboard players operation #BZ meccha.math = #VZ meccha.math
function meccha:lib/vector/dot_product
scoreboard players operation #DLY meccha.math = #DOT meccha.math
# D_w = D . w
scoreboard players operation #AX meccha.math = #DX meccha.math
scoreboard players operation #AY meccha.math = #DY meccha.math
scoreboard players operation #AZ meccha.math = #DZ meccha.math
scoreboard players operation #BX meccha.math = #WX meccha.math
scoreboard players operation #BY meccha.math = #WY meccha.math
scoreboard players operation #BZ meccha.math = #WZ meccha.math
function meccha:lib/vector/dot_product
scoreboard players operation #DLZ meccha.math = #DOT meccha.math

# --- slab in the OBB frame (box centred at 0, half extents H) ---
function meccha:lib/math/aabb_slab
execute if score #SLAB_OK meccha.tmp matches 1 if score #TMIN meccha.math < #BEST_T meccha.math run function meccha:hunter/register_hit
