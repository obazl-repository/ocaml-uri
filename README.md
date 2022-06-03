Uri -- an RFC3986 URI/URL parsing library
-----------------------------------------

BAZEL DEVELOPEMENT TEST branch.

See main branch for original README.md

Configuration:

1. `$ bazel run @opam//local:import -- -v`
2. `$ bazel run @opam//local:refresh`

Step 1 may take a while, since it installs a local OPAM switch.

Test:
1. `$ bazel test lib_test`
