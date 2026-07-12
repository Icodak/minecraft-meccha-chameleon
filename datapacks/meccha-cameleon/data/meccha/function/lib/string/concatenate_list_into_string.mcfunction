# In is the list of string out is the concatenated string storage meccha:lib string_concat.out
data modify storage meccha:lib string.concat.out set value ""

# 2. Start the recursive loop (only if the list actually has items)
execute if data storage meccha:lib string.concat.list[0] run function meccha:lib/string/concat_loop


# storage meccha:lib string_concat.out