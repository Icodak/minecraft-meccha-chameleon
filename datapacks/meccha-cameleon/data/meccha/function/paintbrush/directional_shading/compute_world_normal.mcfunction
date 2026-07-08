# Initialize scale constants
scoreboard players set $2 meccha.math 2
scoreboard players set $10k meccha.math 10000

# Step 1: Start with the default text face vector (0, 0, 1) scaled by 10,000
scoreboard players set $vx meccha.math 0
scoreboard players set $vy meccha.math 0
scoreboard players set $vz meccha.math 10000

# Step 2: Extract right_rotation quaternion components
scoreboard players set $qx meccha.math 0
scoreboard players set $qy meccha.math 0
scoreboard players set $qz meccha.math 0
scoreboard players set $qw meccha.math 0
execute store result score $qx meccha.math run data get entity @s transformation.right_rotation[0] 10000
execute store result score $qy meccha.math run data get entity @s transformation.right_rotation[1] 10000
execute store result score $qz meccha.math run data get entity @s transformation.right_rotation[2] 10000
execute store result score $qw meccha.math run data get entity @s transformation.right_rotation[3] 10000

# Default to identity quaternion if right_rotation is absent or completely blank
execute if score $qx meccha.math matches 0 if score $qy meccha.math matches 0 if score $qz meccha.math matches 0 if score $qw meccha.math matches 0 run scoreboard players set $qw meccha.math 10000

# Step 3: Compute right rotation
function meccha:paintbrush/directional_shading/rotate_vector_by_quat

# Step 4: Extract left_rotation quaternion components
scoreboard players set $qx meccha.math 0
scoreboard players set $qy meccha.math 0
scoreboard players set $qz meccha.math 0
scoreboard players set $qw meccha.math 0
execute store result score $qx meccha.math run data get entity @s transformation.left_rotation[0] 10000
execute store result score $qy meccha.math run data get entity @s transformation.left_rotation[1] 10000
execute store result score $qz meccha.math run data get entity @s transformation.left_rotation[2] 10000
execute store result score $qw meccha.math run data get entity @s transformation.left_rotation[3] 10000

# Default to identity quaternion if left_rotation is absent or completely blank
execute if score $qx meccha.math matches 0 if score $qy meccha.math matches 0 if score $qz meccha.math matches 0 if score $qw meccha.math matches 0 run scoreboard players set $qw meccha.math 10000

# Step 5: Compute left rotation
function meccha:paintbrush/directional_shading/rotate_vector_by_quat

# Step 6: Pass the calculated local coordinates back to data storage as floats
execute store result storage meccha.math normal_local.x float 0.0001 run scoreboard players get $vx meccha.math
execute store result storage meccha.math normal_local.y float 0.0001 run scoreboard players get $vy meccha.math
execute store result storage meccha.math normal_local.z float 0.0001 run scoreboard players get $vz meccha.math

# Step 7: Fire the macro to handle entity yaw and pitch
function meccha:paintbrush/directional_shading/apply_entity_rotation with storage meccha.math normal_local