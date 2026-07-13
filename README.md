# Minecraft Meccha Chameleon

This is Meccha Chameleon remade in **26.2 Vanilla Minecraft** without mods, plugins or resource packs


It's made up of a datapack (namespace `meccha`, pack format `107.1`) and **Python pre-computation pipeline** implementing a custom block/entity rendering and hit-detection engine.

---

## Quick Start

```bash
./build.sh                       # Regenerate assets, compile code, and validate
# In-game (requires Operator status):
/reload
/function meccha:setup           # Dev: Gives raw tools + spawns a demo rig

# Play a round:
/execute as @r run function meccha:role/make_hunter
/execute as @a[tag=!meccha_hunter] run function meccha:role/make_hider
/function meccha:game/start      # Starts countdown and the hunt

```

> 💡 **Need Help?** For a full list of gameplay and developer commands, run `/function meccha:game/help` or `/function meccha:dev/help` directly in-game.

---

## Engine Architecture

* **Asset Pre-Computation Pipeline:** A Python asset pipeline (`tools/`) bakes blockstates, models, and texture coordinates from the game files into into an optimized, flat NBT registry. This heavy data loads exactly once on server startup.
* **Raycast Resolution:** For the **Eyedropper** (reading in-world block model textures to sample colors) I used custom wrappers around the `Bookshelf` library to calculate virtual ray-plane intersections. The **Paintbrush** is done using math only compute native to this pack
* **Modular Display Rigging:** Custom models are constructed using scaled `text_display` entities. Every pixel shares a common cuboid origin, with translation, scale, and quaternion rotations baked into static entity transformations.
* **Dynamic Shading:** Approximates directional lighting by calculating the world-space normal vectors of moving cuboids, adding a tinted shadow to the painted color across six axes. (This feature can be turned on or off in the brush settings)
* **Bounding Volume Hierarchy (BVH) & Hit Detection:** Features a two-tiered raycasting combat system. A fast broad phase checks rays against a global axis-aligned bounding box (AABB), while a narrow phase utilizes the **Separating Axis Theorem (SAT)** to project rays onto individual rotated oriented bounding boxes (OBBs) representing limbs.

---

## Multiplayer & Multi-Rig Architecture

The engine natively supports independent, simultaneous instances for large multiplayer lobbies. The goal was to have real time painting so that the game is playable (obviously)

### Rig Scoping via `rid`

Every spawned rig is assigned a unique **Rig ID (`rid`)**. All associated display entities are tagged with their respective ID (`r<rid>`), and runtime markers store this identifier inside their `data.rid` NBT.

* **Pose & Movement:** Operations target entities matching a specific `r<rid>`.
* **Painting:** Captures the hit cuboid’s `rid` to ensure paint modifications apply strictly to that instance.
* **Hunting:** Damage detection evaluates the broad and narrow phases for each independent `rid`.

### Player Binding & Lifecycle

When a player becomes a hider, `meccha:rig/spawn_for` spawns and ties an independent rig to them.

* **State Tracking:** The player's `meccha.rig` scoreboard holds their bound `rid`, and they receive the `meccha_bound` tag.
* **Tick Execution:** A tick handler runs continuously to move each rig to its respective owner's location and update its pose/shading.
* **Isolation:** Event chains (like item usage or tick passes) run synchronously and sequentially in Minecraft. Scratch scores (`meccha:rt`) and ray markers are cleaned up immediately after execution to prevent cross-player interference. Brush colors are stored per-player (`meccha.color`) so painters never clobber each other.

### Final notes

This was the most advanced datapack I ever made, I hope you can give it a try