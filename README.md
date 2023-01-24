# Backslash l (slosh l)
q/kdb+ utility for loading packages, directories, hdb's and files

## Installation
### Conda
```conda install backslashl```

### Manual
Download latest version, and untar to a packages directory, e.g. ${HOME}/pkg/sloshl-1.0.0
Set QINIT as e.g. ${HOME}/pkg/sloshl-1.0.0/src/sloshl.q

## Usage
Once QINIT is set, utilities will be automatically loaded into your q session. Files and directories can be loaded using .sloshl.load or the import shortcut.

To load packages, the packages must meet some file structure requirements, and the directory those packages are places in should be specified in the QPATH environment variable. 
Multiple paths can be specified in QPATH once they are delimited by a colon, similar to how you would set the PATH environment variable.
```q
$ export QPATH=${HOME}/pkg
$ export QINIT=${HOME}/pkg/sloshl/src/sloshl.q
$ q
q)import`re
q)import"qunit-1.0.0"
q)import"util>=1.0.0"
```

### Package File Structure
Packages should have code in one of either _src_, a folder with the same name as the pkg, or _q_. If a _init.q_ file exists in one of these subdirectories, only that file will be loaded. It is assumed that
any other files that need to be loaded or explicitly specified in _init.q_

