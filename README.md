# Backslash l (\l)
q/kdb+ utility for loading packages, directories, hdb's and files

## Installation
### Conda
```conda install backslashl```

### Manual
Download latest version, and untar to a packages directory, e.g. ${HOME}/pkg/backslashl-1.0.0
Set QINIT as e.g. ${HOME}/pkg/backslashl-1.0.0/src/backslashl.q

## Usage
Once QINIT is set, utilities will be automatically loaded into your q session. Files and directories can be loaded using .backslashl.load or the import shortcut.

To load packages, the packages must meet some file structure requirements, and the directory those packages are places in should be specified in the QPATH environment variable. 
Multiple paths can be specified in QPATH once they are delimited by a colon, similar to how you would set the PATH environment variable.
```q
$ export QPATH=${HOME}/pkg
$ export QINIT=${HOME}/pkg/backslashl/src/backslashl.q
$ q
q)import`re
q)import"qunit-0.0.1"
q)import"util>=0.0.1"
q).backslashl.packages
ppkg     pkg        | name  version fp                                   constraint
--------------------| -------------------------------------------------------------
re-0.0.1 util-0.0.1 | util  "0.0.1" :/Users/doolzer/work/pkg/util-0.0.1  ""
:.       re-0.0.1   | re    "0.0.1" :/Users/doolzer/work/pkg/re-0.0.1    ""
:.       qunit-0.0.1| qunit "0.0.1" :/Users/doolzer/work/pkg/qunit-0.0.1 "-0.0.1"
:.       util-0.0.1 | util  "0.0.1" :/Users/doolzer/work/pkg/util-0.0.1  ">=0.0.1"
q).backslashl.files
fp                                            pkg         time
---------------------------------------------------------------------------------------
:/Users/doolzer/work/pkg/util-0.0.1//util.k   util-0.0.1  2023.02.05D11:01:05.785102000
:/Users/doolzer/work/pkg/re-0.0.1//re.k       re-0.0.1    2023.02.05D11:01:05.785879000
:/Users/doolzer/work/pkg/re-0.0.1//init.q     re-0.0.1    2023.02.05D11:01:05.785889000
:/Users/doolzer/work/pkg/qunit-0.0.1//qunit.q qunit-0.0.1 2023.02.05D11:01:05.799312000
```

Note that once a package has been loaded, the version loaded will be set as a constraint, blocking the same package with a different version being loaded later on.

### Package File Structure
Packages should have code in one of either _src_, a folder with the same name as the pkg, or _q_. If a _init.q_ file exists in one of these subdirectories, only that file will be loaded. It is assumed that
any other files that need to be loaded or explicitly specified in _init.q_

