.backslashl_test.beforeNamespace_createOverrides:{[]
  `AEQ`ATRUE`ATHROWS set'.qunit`assertEquals`assertTrue`assertThrows;
  .backslashl.pkg.qpath:.Q.dd[` sv -1_` vs hsym`$(reverse value .z.s)2;`resources`lib];
  }

.backslashl_test.tearDown_globals:{[]
  .qunit.reset[]
  }

.backslashl_test.test_u_tostr:{[]
  AEQ[.backslashl.u.tostr`symbol;"symbol";"[.backslashl.u.tostr] Successfully casts symbol to string"];
  AEQ[.backslashl.u.tostr`a`b`c;("a";"b";"c"),\:"";"[.backslashl.u.tostr] Successfully casts symbol[] to string[]"];
  AEQ[.backslashl.u.tostr"string";"string";"[.backslashl.u.tostr] If already a string, nothing to do"];
  AEQ[.backslashl.u.tostr("string";"list");("string";"list");"[.backslashl.u.tostr] If already a string[], nothing to do"];
  }

.backslashl_test.test_v_pkg:{[]
  AEQ[.backslashl.v.pkg"pkg-name-1.0.0";`name`version!(`$"pkg-name";"-1.0.0");"[.backslashl.v.pkg] Split pkg name into pkg and version"];
  }

.backslashl_test.test_pkg_load:{[]
  .backslashl.pkg.load"lib-a";
  ATRUE[1=count select from .backslashl.packages where name like"lib-a",version like"2.0.0";"[.backslashl.pkg.load] Loads latest version when constraint-free"];

  .backslashl.pkg.load"lib-b";
  AEQ[exec not any fp like"*/dontload.q"from .backslashl.files where pkg like"lib-b*";"[.backslashl.pkg.load] Loads init.q file only if it exists"];

  time:exec max time from .backslashl.files where pkg like"lib-a*";
  .backslashl.pkg.load"lib-a";
  AEQ[exec max time from .backslashl.files where pkg like"lib-a*";time;"[.backslashl.pkg.load] Does not reload a file if already loaded"];

  ATHROWS[.backslashl.pkg.load;"lib-c";"*Not compatible*";"[.backslashl.pkg.load] Breaks if attempt to load a package that does not satisfy previous constraint"];
  }
