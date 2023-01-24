.sloshl_test.beforeNamespace_createOverrides:{[]
  `AEQ`ATRUE`ATHROWS set'.qunit`assertEquals`assertTrue`assertError
  }

.sloshl_test.tearDown_globals:{[]
  .qunit.reset[]
  }

.sloshl_test.test_u_tostr:{[]
  AEQ[.sloshl.u.tostr`symbol;"symbol";"[.sloshl.u.tostr] Successfully casts symbol to string"];
  AEQ[.sloshl.u.tostr`a`b`c;("a";"b";"c"),\:"";"[.sloshl.u.tostr] Successfully casts symbol[] to string[]"];
  AEQ[.sloshl.u.tostr"string";"string";"[.sloshl.u.tostr] If already a string, nothing to do"];
  AEQ[.sloshl.u.tostr("string";"list");("string";"list");"[.sloshl.u.tostr] If already a string[], nothing to do"];
  }

.sloshl_test.test_v_pkg:{[]
  AEQ[.sloshl.v.pkg"pkg-name-1.0.0";`name`version!(`$"pkg-name";"-1.0.0");"[.sloshl.v.pkg] Split pkg name into pkg and version"];
  }
