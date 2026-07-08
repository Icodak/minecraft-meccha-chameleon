execute unless data storage meccha:game {highlight_overlay:1b} run return 0

function meccha:highlight_rig/enable_highlight
schedule function meccha:highlight_rig/disable_highlight 1s

schedule function meccha:highlight_rig/highlight_loop 2s