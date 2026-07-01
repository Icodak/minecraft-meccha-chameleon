# meccha:lib/block/get_block
# Wrapper over Bookshelf #bs.block:get_block. Run AT the position to inspect.
# Real Bookshelf output is storage bs:out block { type, state, properties, ... }.
# (No block position is provided here - the eyedropper reads it from the
#  raycast lambda $raycast.targeted_block.* instead.)
function #bs.block:get_block
data modify storage meccha:rt block set value {}
data modify storage meccha:rt block.type set from storage bs:out block.type
data modify storage meccha:rt block.state set from storage bs:out block.state
data modify storage meccha:rt block.properties set from storage bs:out block.properties
