# Meccha Chameleon - NBT Schemas

All relational data lives in the storage namespace `meccha:`. Positions in
scoreboards use fixed-point `*1000` (objective `meccha.math`).

## `meccha:registry` (asset data - built once, guarded on `/reload`)

```
meta     : { loaded:1b, version:int, scale:1000 }

textures : {
  "<key>" : { w:int, h:int, px:[ "#RRGGBBAA", ... ] }   # row-major, len w*h
}                                                        # alpha ALWAYS present;
                                                         # "#..00" = transparent

shapes   : {                                  # deduped geometry (Vertex&Face)
  "<shape_id>" : {
    elements : [ { from:[x,y,z], to:[x,y,z], faces:{ <dir>:<FACE> } } ],
    faces    : [ <FACE'> ]                     # flat list for ray iteration
  }
}
# <FACE'> = { dir, el:int,
#             p0:[x,y,z], eu:[x,y,z], ev:[x,y,z],   # face frame (1/16 units)
#             n:[x,y,z],                            # outward unit normal
#             uv:[u1,v1,u2,v2],                    # raw model UV rectangle
#             uvm:[ub,vb,uu,uv,vu,vv],             # pu=ub+u*uu+v*uv; pv=vb+u*vu+v*vv
#             tex:"#var", var:"key", rot:0 }

models   : {                                  # Model-to-Shape/UV
  "<model_id>" : { shape:"<shape_id>", textures:{ "<var>":"<texkey>" } }
}                                              # texture values fully flattened

states   : {                                  # State-to-Model (variants+multipart)
  "<block_id>" : {
    kind  : "variants" | "multipart",
    match : "first" | "all",
    cases : [ { tests:[ {<prop>:<val>}, ... ], apply:[ <APPLY>, ... ] } ]
  }
}                                              # case matches if live properties
# <APPLY> = { model, x, y, z, uvlock:bool, weight }   # contain ANY test subset
```

## `meccha:consts` (lookup tables, rebuilt each load)
```
hex2int : { "00":0, ... "FF":255 }            # hex byte -> int
int2hex : { "0":"00", ... "255":"FF" }        # int -> hex byte (dialog colors)
sin/cos : { "0":0 ... "359":-17 }             # degree -> sin/cos *1000
```

## `meccha:rt` (per-action scratch - rebuilt freely)
```
ray      : { ox,oy,oz, dx,dy,dz : double }    # captured look ray
block    : { id, properties:{...}, pos:[int x,y,z] }   # Bookshelf block result
sample   : { model, shape, textures, color:"#RRGGBBAA", tex, found:bool }
brush    : { color, found, cuboid, face, u:int, v:int }
hunter   : { found:bool, limb, t:int }
rig.pose : "standing" | "crawling" | "superhero_landing"
vec      : { a,b,dot,cross }                  # Bookshelf vector marshalling
```

## `meccha:players` (per-rig BVH - Pillar 7.1, multi-rig)
```
"r<rid>" : {                                  # one entry per rig id
  rid      : int,
  name     : string,
  pose     : string,
  root     : [double x,y,z],                  # rig root world position
  fat_bbox : { c:[double x,y,z], h:[double x,y,z] },   # broad-phase AABB
  limbs    : [ {                              # narrow-phase OBBs
     id     : string,
     rid    : int,
     origin : [double x,y,z],                 # cuboid shared origin (world)
     rot    : [int yaw, int pitch],           # axes via Rx(pitch) then Ry(yaw)
     half   : [double x,y,z],                 # OBB half-extents
     hp     : int
  }, ... ]
}
```
Written by `rig/sync_rig {rid}`. Player->rig binding: the player's `meccha.rig`
score = their rid (+ `meccha_bound` tag). `#RIG_NEXT meccha.sys` = rid allocator.

## Cuboid marker entity NBT (`data` of each `meccha_cuboid` marker)
```
{ cuboid:string, rid:int, size:[int], scale:int, hp:int,
  half:[double x,y,z], cl:[double x,y,z],     # OBB extents + local centre
  off:[double x,y,z],                         # current pose offset from root (follow)
  wfaces:[ { face, p0,eu,ev (origin-relative blocks), n, res:[ru,rv] } ] }
```
Every rig entity (root, cuboid markers, pixels, overlays) is tagged `r<rid>`;
the root also stores `data.rid`, `data.pose`, `data.fat`, and (if bound)
`data.owner` (owner UUID) + the `rig_follow` tag.

## Item custom_data tags (Pillar 3 + gameplay)
`eye_dropper:true` (Arrow) - `paint_brush:true` (Feather) - `hunter_pointer:true` (Blaze Rod) - `pose_switcher:true` (Knowledge Book)

## `meccha:settings` + `meccha:game` (gameplay state)
```
settings : {                                  # persists across /reload
  hide_seconds   : int,    # hunter blindness / hide window (default 30)
  round_seconds  : int,    # hunt duration before hiders win (default 300)
  freeze_hunters : 1b|0b   # root hunters during the hide window
}
game : {
  phase : "idle" | "hiding" | "hunting" | "over",
  timer : int              # remaining ticks in the current phase
}
```
Player role state is held as scoreboard tags: `meccha_hunter` / `meccha_hider`
(+ teams `meccha_hunters` / `meccha_hiders`). The Pose Switcher uses the

## Per-player brush color
```
meccha.color (dummy) : packed 0xRRGGBB, one value PER PLAYER (default white).
```
Set by the eyedropper (`finalize`) and the dialog picker; read by the paintbrush
(`lib/color/unpack` -> opaque ARGB int -> pixel `background`). This is the
multiplayer-safe source of truth for the active color; `meccha:rt last_sample`
is only a global display convenience for `dev/info`.

## Color-picker dialog (`meccha:color_picker/*`)
`data/meccha/dialog/color_picker.json` is a `minecraft:multi_action` dialog
(OKLCH swatch grid + brightness/saturation buttons), generated by
`tools/build_dialog.py`. Buttons fire non-op `/trigger`s read each tick:
```
meccha.pick_rgb  (trigger) : packed 0xRRGGBB + 1   -> @s meccha.color
meccha.pick_adj  (trigger) : 1 brighter, 2 darker, 3 saturate+, 4 saturate-
```
Exposed to players via the `#minecraft:pause_screen_additions` /
`#minecraft:quick_actions` dialog tags. Sets the clicking player's
`meccha.color` (independent from the in-world eyedropper).
