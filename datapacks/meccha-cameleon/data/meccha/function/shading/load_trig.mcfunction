# meccha:shading/load_trig   (macro: $(yaw) $(pitch) integer degrees)
$execute store result score #SINY meccha.math run data get storage meccha:consts sin."$(yaw)"
$execute store result score #COSY meccha.math run data get storage meccha:consts cos."$(yaw)"
$execute store result score #SINP meccha.math run data get storage meccha:consts sin."$(pitch)"
$execute store result score #COSP meccha.math run data get storage meccha:consts cos."$(pitch)"
