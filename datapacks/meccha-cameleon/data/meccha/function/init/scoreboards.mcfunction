# meccha:init/scoreboards
# Fixed-point math objective (world units * 1000), temporaries.
scoreboard objectives add meccha.math dummy
scoreboard objectives add meccha.tmp dummy
# NOTE: the Bookshelf objectives bs.in / bs.out / bs.lambda / bs.data are
# created and owned by Bookshelf's own load (#bs.load:load). We must NOT create
# them here - our wrappers only read/write their fake-player scores at runtime.
# Persistent system counters (game timer accumulation, etc).
scoreboard objectives add meccha.sys dummy
# Dialog color-picker triggers (non-op safe; clicked buttons run /trigger).
scoreboard objectives add meccha.pick_rgb trigger
scoreboard objectives add meccha.pick_adj trigger
# Per-player active brush color, packed as 0xRRGGBB (multiplayer-safe: each
# player carries their own color; set by the eyedropper and the dialog picker,
# read by the paintbrush).
scoreboard objectives add meccha.color dummy
# Per-player bound rig id (which rig this player owns; 0/unset = none).
scoreboard objectives add meccha.rig dummy
# Per-player yaw rotation
scoreboard objectives add meccha.yaw dummy
# Per-player active brush type (multiplayer-safe: each
# player carries their own brush type; set by the brush selection UI,
# read by the paintbrush).
scoreboard objectives add meccha.brush_type trigger

# Per hider state between
# 0: running 
# 1: painting
# 2: spectating
scoreboard objectives add meccha.hider_state dummy

# Prevent item drop: track dropped items and their owners, so we can instantly pick them up again.
scoreboard objectives add meccha.dropped_item dummy

scoreboard objectives add meccha.toggle_leave_spec_mode trigger

scoreboard objectives add meccha.select_team trigger
scoreboard objectives add meccha.select_map trigger
scoreboard objectives add meccha.select_start trigger

scoreboard objectives add meccha.start_screen.location_trigger_value dummy
scoreboard objectives add meccha.selected_location_index dummy


scoreboard objectives add meccha.start_new_round trigger