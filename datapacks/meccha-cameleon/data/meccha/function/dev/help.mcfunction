# meccha:dev/help
# Developer command index for rigs (multi-rig; most take a rig id `rid`).
tellraw @s [{"text":"── Meccha Dev Helpers ──","color":"gold","bold":true}]
tellraw @s [{"text":"Spawn  ","color":"aqua"},{"text":"rig/spawn_for (as player, binds+follows)   rig/init (unbound)   rig/unbind   dev/clear","color":"gray"}]
tellraw @s [{"text":"Pose   ","color":"aqua"},{"text":"rig/pose_set {rid,pose,direction}   (hiders: right-click Pose Switcher)","color":"gray"}]
tellraw @s [{"text":"Move   ","color":"aqua"},{"text":"rig/move_to {rid,x,y,z}   dev/move_cuboid {rid,cuboid,dx,dy,dz}","color":"gray"}]
tellraw @s [{"text":"Rotate ","color":"aqua"},{"text":"dev/rotate_cuboid {rid,cuboid,yaw,pitch}","color":"gray"}]
tellraw @s [{"text":"Paint  ","color":"aqua"},{"text":"dev/paint_pixel {rid,cuboid,face,u,v,color}   dev/paint_face {rid,cuboid,face,color}   dev/paint_all {color}","color":"gray"}]
tellraw @s [{"text":"Glow   ","color":"aqua"},{"text":"dev/glow_cuboid {rid,cuboid}   dev/unglow","color":"gray"}]
tellraw @s [{"text":"Info   ","color":"aqua"},{"text":"dev/info   dev/info_cuboid {rid,cuboid}   dev/list_cuboids   rig/debug","color":"gray"}]
tellraw @s [{"text":"Visual ","color":"aqua"},{"text":"dev/show_bvh   dev/show_axes   dev/hide_overlays   dev/show_overlays","color":"gray"}]
tellraw @s [{"text":"Colour ","color":"aqua"},{"text":"dialog/open  (or pause-menu → Quick Actions: Colour Picker)","color":"gray"}]
