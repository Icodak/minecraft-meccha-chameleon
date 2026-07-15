execute as @e[type=marker,tag=meccha_rig_root] run function meccha:scoring/copy_score_from_rig
schedule function meccha:scoring/periodic_score_copy 2s