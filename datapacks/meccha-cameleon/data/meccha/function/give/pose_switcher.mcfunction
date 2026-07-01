# meccha:give/pose_switcher
# Pose Switcher (Knowledge Book). Right-click cycles the hider pose.
# We deliberately AVOID `consumable` (a continuous trigger). A knowledge book
# is CONSUMED on right-click and increments meccha.use_pose
# (minecraft.used:minecraft.knowledge_book); meccha:tick detects that, cycles
# the pose, and re-gives the book (see role/pose_used). The bundled recipe is
# one players already know, so no recipe toast appears.
#
# Fallback: if a future version stops firing `used:knowledge_book`, swap this
# for minecraft:snowball + criterion minecraft.used:minecraft.snowball.
give @s minecraft:knowledge_book[minecraft:recipes=[crafting_table],minecraft:custom_data={pose_switcher:true},minecraft:item_name={"text":"Pose Switcher","color":"yellow"}] 1
