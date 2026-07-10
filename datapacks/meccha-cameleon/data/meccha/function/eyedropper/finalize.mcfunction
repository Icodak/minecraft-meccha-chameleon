# meccha:eyedropper/finalize (executed AS the sampling player)
# Store the sampled color as THIS player's brush color.
data modify storage meccha:rt col.hex set from storage meccha:rt sample.color
data modify storage meccha:rt col.rr set string storage meccha:rt col.hex 1 3
data modify storage meccha:rt col.gg set string storage meccha:rt col.hex 3 5
data modify storage meccha:rt col.bb set string storage meccha:rt col.hex 5 7
data modify storage meccha:rt col.aa set string storage meccha:rt col.hex 7 9

# Convert hex components to scores/integers
function meccha:lib/color/lookup_argb with storage meccha:rt col
function meccha:lib/color/pack

# Ensure the packed result from the eyedropper sets the exact same player score
# (Assuming meccha:lib/color/pack stores its final result in #P meccha.tmp)
scoreboard players operation @s meccha.color = #P meccha.tmp

# Mirror the exact storage structure from apply_rgb
execute store result storage meccha:rt rgb.r int 1 run scoreboard players get #R meccha.tmp
execute store result storage meccha:rt rgb.g int 1 run scoreboard players get #G meccha.tmp
execute store result storage meccha:rt rgb.b int 1 run scoreboard players get #B meccha.tmp

# Display & Logging alignment
data modify storage meccha:rt last_sample set from storage meccha:rt sample.color
data modify storage meccha:rt sample.rgb set string storage meccha:rt sample.color 0 7

# Persist this player's chosen color under the per-player storage map.
data modify storage meccha:player color set from storage meccha:rt sample.rgb

function meccha:lib/color/store_player_color with storage meccha:player

# You can now cleanly route this to build_hex or keep your feedback function 
# knowing they share the exact same 'rgb' and 'sample.rgb' data states.
function meccha:eyedropper/feedback with storage meccha:rt sample