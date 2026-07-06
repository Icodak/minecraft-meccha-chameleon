# Meccha Chameleon - Vanilla Rendering & Hunter Engine

A vanilla **Minecraft Java 26.2 "Chaos Cubed"** datapack (namespace `meccha`,
pack format **107.1**) plus a **Python pre-computation pipeline** that implements
a custom block/entity rendering and hit-detection engine - no mods. Built around
7 pillars.

> **Bookshelf dependency:** raycasting, `dot`/`cross` products and block lookup
> use [Bookshelf](https://docs.mcbookshelf.dev) v4.1 (bundled under `data/bs.*`
> with the `load` library). All Bookshelf calls are isolated behind thin
> wrappers so the engine has a single integration surface:
> * `meccha:lib/vector/{dot_product,cross_product}` - set `$vector.*.u/v bs.in`
>   scores, call `#bs.vector:* {scaling:1000}`, read `$vector.* bs.out`.
> * `meccha:lib/block/get_block` - calls `#bs.block:get_block`, reads
>   `bs:out block.{type,state,properties}`.
> * `meccha:lib/raycast/run_block` - `#bs.raycast:run {with:{...,
>   on_targeted_block:"function meccha:eyedropper/on_block_entry"}}`; the callback
>   reads the `$raycast.targeted_block.* bs.lambda` scores.

## Quick start
```bash
./build.sh                       # regenerate generated/ + rig/ from assets, validate
# in-game (ops):
/reload
/function meccha:setup            # dev: gives raw tools + spawns a demo rig
# play a round (ops):
/execute as @r run function meccha:role/make_hunter
/execute as @a[tag=!meccha_hunter] run function meccha:role/make_hider
/function meccha:game/start        # countdown + hunter blindness, then the hunt
/function meccha:game/help         # full gameplay command list
```

## Developer & debug helpers (`meccha:dev/*`)
Run `/function meccha:dev/help` in-game for the live index. All helpers act on
the rig spawned by `meccha:rig/init` / `meccha:setup`. Functions taking
arguments are macros - call them with an SNBT compound, e.g.
`/function meccha:dev/rotate_cuboid {cuboid:"arm_l",yaw:0,pitch:45}`.

**Spawn / teardown**
| Function | Args | Purpose |
|---|---|---|
| `dev/spawn_rig` | - | Spawn a full hider rig at your feet (alias of `rig/init`). |
| `dev/spawn_cuboid` | `cuboid` | Spawn ONE cuboid in isolation for close inspection. |
| `dev/clear` | - | Despawn all rig entities (alias of `reset_rig`). |

**Pose / move / rotate**
| Function | Args | Purpose |
|---|---|---|
| `rig/poses/standing` - `crawling` - `superhero_landing` | - | Switch the whole-rig pose. |
| `rig/move_to` | `x,y,z` | Force-move the rig to world coords, then re-pose. |
| `dev/move_cuboid` | `cuboid,dx,dy,dz` | Translate one cuboid by a relative offset. |
| `dev/rotate_cuboid` | `cuboid,yaw,pitch` | Set one cuboid's rotation (re-runs shading + affects OBB hits). |

**Paint (test colour/UV addressing)**
| Function | Args | Purpose |
|---|---|---|
| `dev/paint_pixel` | `cuboid,face,u,v,color` | Recolour one pixel by its tags (`color` = `"#RRGGBBAA"`). |
| `dev/paint_face` | `cuboid,face,color` | Recolour every pixel of one face. |
| `dev/paint_all` | `color` | Flood the whole rig with one colour. |

**Glow / visibility**
| Function | Args | Purpose |
|---|---|---|
| `dev/glow_cuboid` | `cuboid` | Outline a cuboid's pixels (white glow) to locate it. |
| `dev/unglow` | - | Clear all pixel glow. |
| `dev/hide_overlays` | - | Make shading overlays transparent (inspect raw colours). |
| `dev/show_overlays` | - | Recompute all shading overlays now. |

**Info / inspect**
| Function | Args | Purpose |
|---|---|---|
| `dev/info` | - | Overview: registry status, pose, entity counts, last brush colour. |
| `dev/info_cuboid` | `cuboid` | Dump one cuboid's marker data + live world pose. |
| `dev/list_cuboids` | - | List every cuboid with origin + rotation. |
| `rig/debug` | - | Full rig transformation-state dump. |

**Visualise the BVH (Pillar 7)**
| Function | Args | Purpose |
|---|---|---|
| `dev/show_bvh` | - | Draw the Fat AABB corners (broad phase) + limb axes (narrow phase). |
| `dev/show_axes` | - | Draw each cuboid's rotated local axes (X=flame, Y=crit, Z=happy_villager). |

## Gameplay - roles & rounds (`meccha:role/*`, `meccha:game/*`)
A lightweight hide-&-seek loop on top of the engine. Run
`/function meccha:game/help` for the in-game index.

**Assign / clear roles** (run *as* the target player, e.g. via `execute as`)
| Function | Purpose |
|---|---|
| `role/make_hider` | Tag + green team + Hider kit (Eyedropper, Paintbrush, Pose Switcher). |
| `role/make_hunter` | Tag + red team + Hunter kit (Hunter Pointer). |
| `role/clear` | Remove this player's role, items, team and effects. |
| `role/clear_all` | Strip roles from **every** player (game teardown). |

```
# assign roles
/execute as @r run function meccha:role/make_hunter
/execute as @a[tag=!meccha_hunter] run function meccha:role/make_hider
```

**Run a round**
| Function | Args | Purpose |
|---|---|---|
| `game/start` | - | Begin the **hiding** phase: title countdown + hunters blinded/frozen for `hide_seconds`. |
| `game/stop` | - | End the round (lifts hunter effects); keeps roles for a quick rematch. |
| `game/reset` | - | Full teardown: stop + `role/clear_all` + despawn rig + back to idle. |
| `game/hunters_win` - `game/hiders_win` | - | Declare a winner (call from your own elimination logic / timeout). |
| `game/settings` | - | Print current phase + settings. |

**Round settings** (persist across `/reload`)
| Function | Args | Default | Purpose |
|---|---|---|---|
| `game/set_hide_time` | `seconds` | 30 | How long hunters stay blinded while hiders scatter. |
| `game/set_round_time` | `seconds` | 300 | Hunt duration before hiders win by timeout. |
| `settings.freeze_hunters` | `1b`/`0b` | `1b` | Whether hunters are rooted (slowness) during the hide window. |

**Flow:** `game/start` -> *hiding* (every second a **title countdown** shows
"Hunt begins in Ns" to hiders and "Vision returns in Ns" to the blinded
hunters) -> at 0, `end_hide` clears the blindness and opens the **hunting**
phase (remaining time on the action bar) -> timeout -> `hiders_win`. The hunter's
vision is hidden via `blindness`+`darkness` for exactly `hide_seconds`
(customisable). All state lives in `storage meccha:game` / `meccha:settings`
and is driven from `meccha:game/tick`.

**Pose Switcher (no `consumable`):** hiders right-click the **Knowledge Book**
to cycle stance (standing -> crawling -> superhero_landing). Using a knowledge book is a
*discrete* event - it increments the `minecraft.used:minecraft.knowledge_book`
scoreboard criterion (read in `meccha:tick`), unlike the continuous
`consumable` trigger. The book is consumed and silently re-given each click.

## Colour-picker menu (Dialog UI)
A second, in-menu way to choose the brush colour - **fully decorrelated** from
the in-world eyedropper. Built on the 1.21.6+ **Dialog** system
(`data/meccha/dialog/color_picker.json`, generated by `tools/build_dialog.py`).

* A `minecraft:multi_action` dialog whose body is a **perceptually-uniform
  OKLCH swatch grid** (hue across the 12 columns, lightness down the rows, plus
  a grayscale row). Each button is a tinted `■■` square.
* **Below the grid**: `☀ Brighter` / `☾ Darker` / `◈ Saturate +` / `◇ Saturate -`
  adjust the currently-selected colour.
* Every button runs a **non-op-safe** `/trigger` (swatches -> `meccha.pick_rgb`
  = packed `0xRRGGBB+1`; adjust -> `meccha.pick_adj` = 1..4). `meccha:dialog/tick`
  decodes the packed value to `#RRGGBB` (via the `int2hex` table) and sets the
  same `last_sample` the Paintbrush uses. Brightness/saturation are applied in
  RGB space (luma-relative) in `dialog/apply_adj`.
* `pause:false` + `after_action:"none"` keep the menu open so colours can be
  tried live (the tick handler runs while the dialog is up).

**Open it:**
| How | Detail |
|---|---|
| Pause menu / **Quick Actions** key | Registered via the `#minecraft:pause_screen_additions` and `#minecraft:quick_actions` dialog tags - no operator needed. |
| `/function meccha:dialog/open` | Operator helper (runs `/dialog show @s meccha:color_picker`). |

Regenerate with a different layout: `python tools/build_dialog.py --datapack . --hues 12 --rows 8`.

## Repository layout
```
pack.mcmeta
build.sh                         # runs both generators + validator
tools/                           # Pillar 2 + 5 Python pipeline
  parse_assets.py                #   asset -> registry builders
  build_rig.py                   #   rig spec -> spawn functions
  build_dialog.py                #   OKLCH colour-picker -> dialog JSON
  validate_pack.py               #   static datapack linter
  lib/                           #   blockstate/model/texture/shape/writer modules
  sample_assets/                 #   runnable demo assets
data/
  minecraft/tags/{function,dialog}/  # load/tick hooks + dialog menu tags
  bs.block/ bs.vector/ bs.raycast/ bs.hitbox/ bs.load/ load/   # Bookshelf + load lib
  meccha/
    function/
      load, tick, setup, reset_rig
      init/                      # Pillar 1 scaffolding + lookup tables
      generated/                 # Pillar 2 OUTPUT (do not hand-edit)
      lib/{raycast,vector,math,block,color}/   # Bookshelf wrappers + math
      trigger/                   # Pillar 3 advancement reward fns
      eyedropper/  paintbrush/   # Pillar 4
      rig/  rig/poses/           # Pillar 5
      shading/                   # Pillar 6
      hunter/                    # Pillar 7
      role/  game/               # gameplay: roles, kits, round flow
      dialog/                    # colour-picker Dialog handlers
      dev/                       # developer/debug helpers (meccha:dev/*)
    advancement/                 # Pillar 3 triggers
    dialog/                      # Dialog UI defs (color_picker.json)
docs/                            # NBT_SCHEMA.md + bundled Bookshelf module docs
```

---

## Pillar 1 - Project init & storage guard
* Folder tree above (modern singular dirs: `function/`, `advancement/`, `tags/function/`).
* `meccha:load` rebuilds cheap scaffolding every reload but guards the heavy
  relational build: `execute unless data storage meccha:registry meta.loaded run
  function meccha:init/build_registry`. So multi-MB asset NBT loads **once**.

## Pillar 2 - Pre-computation pipeline (`tools/`)
`parse_assets.py` parses `assets/minecraft/`:
* `blockstate_parser.py` - handles **both** `variants` and `multipart`
  (`when`/`OR`/`AND`/`apply`), pre-expanding predicates into concrete
  `tests` subsets so in-game matching is a single `if data` containment check.
* `model_resolver.py` - follows `parent` chains, flattens `textures`, resolves
  every `elements` cuboid into **face geometry** (`p0/eu/ev/normal/uv`) with
  element `rotation` baked in.
* `shape_grouper.py` - hashes geometry and interns common silhouettes
  (`full_block`, `slab_bottom`, `stairs`, ...) so duplicate shapes collapse.
* `texture_quantizer.py` - PNG -> row-major `#RRGGBBAA` array, **alpha always
  recorded** (`#00000000` transparent).
* Emits four builders + `_index`: **Texture**, **State-to-Model**,
  **Model-to-Shape/UV**, **Vertex&Face** (`data/meccha/function/generated/`).

## Pillar 3 - Interaction triggers
* `meccha:give/tools` - Eyedropper (Arrow), Paintbrush (Feather), Hunter Pointer
  (Blaze Rod). All use the 1.21.2+ `consumable` component with a 1e7s
  (effectively infinite) consume time + `custom_data` flags.
* `advancement/{eyedropper,paintbrush,hunter}_use.json` - hidden
  `consume_item` triggers checking the respective `custom_data` predicate.
* Reward `trigger/*` fns **revoke the advancement immediately** then run the
  action - so it re-fires indefinitely.

## Pillar 4 - Eyedropper vs Paintbrush
* **Eyedropper** (`eyedropper/`): `#bs.raycast:run` with an
  `on_targeted_block` callback (Step 1) -> `#bs.block:get_block` reads
  `bs:out block.type/properties`, matched against the registry `cases`
  (Step 2) -> **secondary virtual raycast** over the shape faces using
  `t = ((P0 - O)-N)/(D-N)`, `P = O + tD`, mapped to `uv` -> hex (Step 3). The block
  origin comes from the `$raycast.targeted_block.* bs.lambda` scores.
  Transparent texels (`#..00`) are skipped and do **not** advance the
  nearest-hit, so the ray sees through them. Only the **in-world block model**
  is parsed - inventory / first-person item models are ignored.
* **Paintbrush** (`paintbrush/`): purely virtual raycast against the rig
  cuboids' planes -> nearest sub-face -> localized `(u,v)` -> targets the exact
  pixel via `@e[...tag=cb_X,tag=face_Y,tag=u_I,tag=v_J]` and writes its
  `background`.

## Pillar 5 - Modular cuboid rigging (`build_rig.py`, `rig/`)
* Pixels are 1/16-block `text_display`s; the **1/3 hider scale** reduces the
  pixel *count* (~1632 -> ~164) while each pixel stays exactly 1/16 block.
* Every pixel of a cuboid shares one origin + rotation; per-pixel placement is
  baked into a **static `transformation`** (translation + `left_rotation`
  quaternion + scale). Unique tags `cb_/face_/u_/v_` index each pixel.
* Poses (`rig/poses/{standing,crawling,superhero_landing}`) are transform stacks applied
  by **`/tp`-ing the shared cuboid origin** (`rig/apply_pose`).
* Debug: `rig/debug` (tellraw state dump), `rig/move_to` (force-move + re-pose).

## Pillar 6 - Directional shading (`shading/`)
* 6 stretched semi-transparent overlays per cuboid. On a pose change the cuboid
  is flagged `pose_dirty`; the tick pass recomputes each face's **world normal**
  (`lib/math/rot_normal` via the sin/cos table), classifies it against the 6
  axes, and sets the overlay alpha to `1 - multiplier`:
  Top 1.0 - N/S 0.8 - E/W 0.6 - Bottom 0.5.

## Pillar 7 - Hunter BVH (`hunter/`)
* **Schema** (`docs/NBT_SCHEMA.md` -> `meccha:players`): root Fat BBox + per-limb
  OBBs; written by `hunter/sync_player`.
* **Broad phase** (`broad_phase`): **AABB slab** vs the Fat BBox; misses
  discarded instantly.
* **Narrow phase** (`test_obb`): **OBB via SAT** - builds the cuboid's rotated
  axes (`w = u * v` via `#bs.vector:cross_product`), **projects** the ray onto
  each axis with `#bs.vector:dot_product`, then slab-tests in the box frame.
  Nearest limb wins; `hp` is docked.

---

## Notes & assumptions
* **Target: Minecraft Java 26.2 "Chaos Cubed"** (pack format **107.1**).
  `pack.mcmeta` uses the modern `min_format`/`max_format` fields
  (`[major, minor]`); the old `pack_format`/`supported_formats` were removed in
  the 25w31a+ schema. Adjust the range for other versions.
* Display `transformation` fields are emitted as **floats** (`f`); doubles can
  make a display entity fail to load. Custom marker `data` stays doubles (read
  back via `data get <scale>`).
* The 26.2 *entity* predicate overhaul does **not** affect this pack - the
  advancements use *item* predicates (`predicates.minecraft:custom_data`), which
  were already component-style and are unchanged.
* Textures are assumed 16 * 16 sprites for the eyedropper texel index; the schema
  carries `w/h` to generalize.
* The brush colour is **per-player**: a packed `0xRRGGBB` in the `meccha.color`
  scoreboard, set by the eyedropper and the dialog picker and read by the
  paintbrush - painters never clobber each other. (`last_sample` storage is kept
  only for `dev/info` display.)
* `validate_pack.py` is a static linter (bracket balance, macro `$` prefixes,
  dangling `function` references), not a full Minecraft parser.

## Multiplayer & multi-rig
Fully multi-rig. Every rig gets a unique **rig id** (`rid`); all its entities are
tagged `r<rid>` and its markers store `data.rid`, so **pose, paint and hunt are
scoped per rig**.

**Per-player binding.** `meccha:rig/spawn_for` (run *as* a player) spawns a rig
and binds it: the player's `meccha.rig` score holds the rid, they get the
`meccha_bound` tag, and the rig **follows them** each tick (`rig/follow`).
`role/make_hider` does this automatically; `make_hunter`/`role/clear`/`rig/unbind`
release it. Multiple hiders each carry their own independent rig.

| Action | Scope | How |
|---|---|---|
| Pose cycle | the player's **bound** rig (`meccha.rig`) | `role/cycle_pose` -> `rig/pose_set {rid,pose}` |
| Paint | the rig the ray **hits** | `record_hit` captures the cuboid's `data.rid`; `paint_pixel` targets `r<rid>` |
| Hunt | **each** hider rig independently | `broad_phase` per root -> `narrow_phase` scoped to that root's `rid` |
| Follow | each **bound** rig | tick moves it to its owner and re-applies its pose |

Rig lifecycle: `rig/spawn_for` (bind), `rig/init` (unbound), `rig/move_to
{rid,x,y,z}`, `rig/pose_set {rid,pose}`, `rig/unbind`, `rig/despawn {rid}`,
`reset_rig` (all rigs). Dev helpers take a `rid` (e.g. `dev/rotate_cuboid
{rid,cuboid,yaw,pitch}`).

**Per-player** otherwise: roles/teams, brush colour (`meccha.color`), dialog
triggers, item interactions, titles/effects. Round state (`meccha:game`) +
settings are global (a round is server-wide). Per-action scratch (`meccha:rt`,
`#…` scores, ray markers) is used **synchronously** per event chain (advancement
rewards + tick handlers run sequentially - no cross-player interleaving); ray
markers are defensively pre-killed.

*Perf note:* a followed rig re-applies its pose every tick (so it also re-runs
directional shading). Cheap for a handful of hiders; for large lobbies this is
the first thing to optimise (reposition cuboids from stored `data.off` without
re-flagging shading).
