# meccha:lib/color/lookup   (macro: $(rr) $(gg) $(bb) $(aa) are hex byte strings)
# Resolve each hex byte to its 0..255 value via the hex2int table.
# $say lookup $(rr) $(gg) $(bb) $(aa)
$execute store result score #RRv meccha.math run data get storage meccha:consts hex2int."$(rr)"
$execute store result score #GGv meccha.math run data get storage meccha:consts hex2int."$(gg)"
$execute store result score #BBv meccha.math run data get storage meccha:consts hex2int."$(bb)"
$execute store result score #AAv meccha.math run data get storage meccha:consts hex2int."$(aa)"
