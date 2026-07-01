# meccha:init/scoreboards
# Fixed-point math objective (world units * 1000), temporaries.
scoreboard objectives add meccha.math dummy
scoreboard objectives add meccha.tmp dummy
# NOTE: the Bookshelf objectives bs.in / bs.out / bs.lambda / bs.data are
# created and owned by Bookshelf's own load (#bs.load:load). We must NOT create
# them here \u2014 our wrappers only read/write their fake-player scores at runtime.
# Persistent system counters (game timer accumulation, etc).
scoreboard objectives add meccha.sys dummy
# Discrete right-click detection for the Pose Switcher (knowledge book).
# Using a knowledge book always CONSUMES it and increments this `used:`
# criterion exactly once per right-click \u2014 a clean discrete alternative to the
# continuous `consumable` trigger. We re-give the book after each use.
scoreboard objectives add meccha.use_pose minecraft.used:minecraft.knowledge_book
# Dialog colour-picker triggers (non-op safe; clicked buttons run /trigger).
scoreboard objectives add meccha.pick_rgb trigger
scoreboard objectives add meccha.pick_adj trigger
# Per-player active brush colour, packed as 0xRRGGBB (multiplayer-safe: each
# player carries their own colour; set by the eyedropper and the dialog picker,
# read by the paintbrush).
scoreboard objectives add meccha.color dummy
# Per-player bound rig id (which rig this player owns; 0/unset = none).
scoreboard objectives add meccha.rig dummy
