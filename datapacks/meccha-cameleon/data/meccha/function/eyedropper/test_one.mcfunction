# meccha:eyedropper/test_one   (macro: $(cur_test) is a property subset compound)
# Containment check: does the live block.properties include this subset?
$execute if data storage meccha:rt {block:{properties:$(cur_test)}} run data modify storage meccha:rt match set value 1b
