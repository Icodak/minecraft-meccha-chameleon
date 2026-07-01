# meccha:game/freeze_hunters   (macro: $(hide_seconds))
# Root hunters during the hide window: slowness 250 fully stops horizontal
# movement (combined with blindness they can't relocate). We avoid the old
# negative jump_boost trick \u2014 it no longer prevents jumping in modern versions.
$effect give @a[tag=meccha_hunter] minecraft:slowness $(hide_seconds) 250 true
