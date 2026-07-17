# fly:load - initialise scoreboard objectives used by the flight system
# fly.jumpPrev : jump-key state on the previous tick (for rising-edge detection)
# fly.tap      : countdown (ticks) for the double-tap window, used both to enter and to exit (0.3s = 6 ticks)
# fly.state    : current flight movement state (0 = hover, 1 = rise, 2 = slow-fall)
scoreboard objectives add fly.jumpPrev dummy
scoreboard objectives add fly.tap dummy
scoreboard objectives add fly.state dummy

tellraw @a [{"text":"[Fly] ","color":"aqua","bold":true},{"text":"Survival flight loaded. Players with the ","color":"gray"},{"text":"can_fly","color":"green"},{"text":" tag can double-tap Jump in mid-air to start flying.","color":"gray"}]
