# meccha:eyedropper/bake_faces_step
# Pop one face, resolve its texture variable against THIS part's texture map
# (baking the final key so the raycast is self-contained across mixed-texture
# multipart parts), then append it to the combined list.
data modify storage meccha:rt bface set from storage meccha:rt partfaces[0]
data remove storage meccha:rt partfaces[0]
data modify storage meccha:rt bface.tex set value ""
data modify storage meccha:rt marg set value {}
data modify storage meccha:rt marg.var set from storage meccha:rt bface.var
function meccha:eyedropper/bake_tex with storage meccha:rt marg
data modify storage meccha:rt faces append from storage meccha:rt bface
function meccha:eyedropper/bake_faces
