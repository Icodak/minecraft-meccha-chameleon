# --- Compute cross product t = 2 * (q x v) ---
# tx component
scoreboard players operation $t1 meccha.math = $qy meccha.math
scoreboard players operation $t1 meccha.math *= $vz meccha.math
scoreboard players operation $t2 meccha.math = $qz meccha.math
scoreboard players operation $t2 meccha.math *= $vy meccha.math
scoreboard players operation $t1 meccha.math -= $t2 meccha.math
scoreboard players operation $t1 meccha.math *= $2 meccha.math
scoreboard players operation $tx meccha.math = $t1 meccha.math
scoreboard players operation $tx meccha.math /= $10k meccha.math

# ty component
scoreboard players operation $t1 meccha.math = $qz meccha.math
scoreboard players operation $t1 meccha.math *= $vx meccha.math
scoreboard players operation $t2 meccha.math = $qx meccha.math
scoreboard players operation $t2 meccha.math *= $vz meccha.math
scoreboard players operation $t1 meccha.math -= $t2 meccha.math
scoreboard players operation $t1 meccha.math *= $2 meccha.math
scoreboard players operation $ty meccha.math = $t1 meccha.math
scoreboard players operation $ty meccha.math /= $10k meccha.math

# tz component
scoreboard players operation $t1 meccha.math = $qx meccha.math
scoreboard players operation $t1 meccha.math *= $vy meccha.math
scoreboard players operation $t2 meccha.math = $qy meccha.math
scoreboard players operation $t2 meccha.math *= $vx meccha.math
scoreboard players operation $t1 meccha.math -= $t2 meccha.math
scoreboard players operation $t1 meccha.math *= $2 meccha.math
scoreboard players operation $tz meccha.math = $t1 meccha.math
scoreboard players operation $tz meccha.math /= $10k meccha.math

# --- Compute w * t / 10,000 ---
scoreboard players operation $wtx meccha.math = $qw meccha.math
scoreboard players operation $wtx meccha.math *= $tx meccha.math
scoreboard players operation $wtx meccha.math /= $10k meccha.math

scoreboard players operation $wty meccha.math = $qw meccha.math
scoreboard players operation $wty meccha.math *= $ty meccha.math
scoreboard players operation $wty meccha.math /= $10k meccha.math

scoreboard players operation $wtz meccha.math = $qw meccha.math
scoreboard players operation $wtz meccha.math *= $tz meccha.math
scoreboard players operation $wtz meccha.math /= $10k meccha.math

# --- Compute q x t / 10,000 ---
scoreboard players operation $t1 meccha.math = $qy meccha.math
scoreboard players operation $t1 meccha.math *= $tz meccha.math
scoreboard players operation $t2 meccha.math = $qz meccha.math
scoreboard players operation $t2 meccha.math *= $ty meccha.math
scoreboard players operation $t1 meccha.math -= $t2 meccha.math
scoreboard players operation $qtx meccha.math = $t1 meccha.math
scoreboard players operation $qtx meccha.math /= $10k meccha.math

scoreboard players operation $t1 meccha.math = $qz meccha.math
scoreboard players operation $t1 meccha.math *= $tx meccha.math
scoreboard players operation $t2 meccha.math = $qx meccha.math
scoreboard players operation $t2 meccha.math *= $tz meccha.math
scoreboard players operation $t1 meccha.math -= $t2 meccha.math
scoreboard players operation $qty meccha.math = $t1 meccha.math
scoreboard players operation $qty meccha.math /= $10k meccha.math

scoreboard players operation $t1 meccha.math = $qx meccha.math
scoreboard players operation $t1 meccha.math *= $ty meccha.math
scoreboard players operation $t2 meccha.math = $qy meccha.math
scoreboard players operation $t2 meccha.math *= $tx meccha.math
scoreboard players operation $t1 meccha.math -= $t2 meccha.math
scoreboard players operation $qtz meccha.math = $t1 meccha.math
scoreboard players operation $qtz meccha.math /= $10k meccha.math

# --- Accumulate terms: v' = v + wt + qt ---
scoreboard players operation $vx meccha.math += $wtx meccha.math
scoreboard players operation $vx meccha.math += $qtx meccha.math

scoreboard players operation $vy meccha.math += $wty meccha.math
scoreboard players operation $vy meccha.math += $qty meccha.math

scoreboard players operation $vz meccha.math += $wtz meccha.math
scoreboard players operation $vz meccha.math += $qtz meccha.math