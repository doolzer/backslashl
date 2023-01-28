.backslashl_test.beforeNamespace_createOverrides:{[]
  `AEQ`ATRUE`ATHROWS set'.qunit`assertEquals`assertTrue`assertError
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
