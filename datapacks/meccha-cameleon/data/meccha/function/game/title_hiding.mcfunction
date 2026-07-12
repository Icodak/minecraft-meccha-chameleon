# meccha:game/title_hiding   (macro: $(sec))
# Send subtitle first, then title (title triggers the on-screen display).
$title @a[tag=meccha_hider] actionbar [{"text":"Hunt begins in ","color":"white"},{"text":"$(sec)s","color":"yellow"}]
title @a[tag=meccha_hider] title [{"text":"Hide!","color":"green","bold":true}]
$title @a[tag=meccha_hunter] subtitle [{"text":"Vision returns in ","color":"gray"},{"text":"$(sec)s","color":"yellow"}]
title @a[tag=meccha_hunter] title [{"text":"Blinded","color":"dark_red","bold":true}]
