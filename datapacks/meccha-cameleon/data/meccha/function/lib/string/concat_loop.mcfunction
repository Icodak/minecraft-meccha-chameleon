# 1. Package the current result and the next string into a macro arguments object
data modify storage meccha:lib string.concat.base set from storage meccha:lib string.concat.out
data modify storage meccha:lib string.concat.next set from storage meccha:lib string.concat.list[0]

# 2. Run the macro to glue them together
function meccha:lib/string/concat_macro with storage meccha:lib string.concat

# 3. Remove the string we just processed from the front of the list
data remove storage meccha:lib string.concat.list[0]

# 4. If there are still items left in the list, loop again!
execute if data storage meccha:lib string.concat.list[0] run function meccha:lib/string/concat_loop