

#!/bin/bash q
\l src/backslashl.q
import`qunit
import`test
.qunit.runTests`.backslashl_test
exit 0
