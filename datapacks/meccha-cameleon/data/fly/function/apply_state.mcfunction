# fly:apply_state - pick the flight behaviour from the current key presses
# Priority: Jump (rise) > Sneak (slow fall) > neither (hover, gravity 0)
execute if predicate fly:pressing_jump run function fly:state_rise
execute unless predicate fly:pressing_jump if predicate fly:pressing_sneak run function fly:state_slowfall

# Neither key held -> hover. If we were rising or slow-falling last tick,
# brake first so momentum doesn't carry into the hover.
execute unless predicate fly:pressing_jump unless predicate fly:pressing_sneak if score @s fly.state matches 1..2 at @s run function fly:brake
execute unless predicate fly:pressing_jump unless predicate fly:pressing_sneak run function fly:state_hover
