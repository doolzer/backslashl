/ @package  backslashl
/ @author   Colin Dooley
/ @date     2023.01.14
/ @about    q package and file loading framework (slosh l)

\d .backslashl

// GLOBALS
/ Tables below will keep track of what file loaded what, and which file belongs to which package, if that information is available.
files:1!select fp,pkg from packages:([pkg:`$()]name:`$();version:();fp:`$();ppkg:`$());

/ Context object will keep bearings as traverse through package dependencies
context.switch:{[info]
  $[(::)~info;context.fp::hsym context.pkg::`:.;99=type info;context,:(k:`pkg`fp inter key info)#info;'`type];
  }

/ @param  x   - [string] Version string typically of the form <major>.<minor>.<patch>
/ @param  y   - [string] Version string typically of the form <major>.<minor>.<patch>
/ @result     - [bool] Compares x and y version strings, returning true if equal (2.8.0 == 2.8), false otherwise
v.eq:{min .[=]N#'r,\:(N:max count each r:"J"$"."vs'(x;y))#0j}

/ @param  x   - [string] Version string typically of the form <major>.<minor>.<patch>
/ @param  y   - [string] Version string typically of the form <major>.<minor>.<patch>
/ @result     - [bool] Compares x and y version strings, returning true if x less than y, false otherwise
v.lt:{max[.[<]r]&all .[<=]r:N#'r,\:(N:max count each r:"J"$"."vs'(x;y))#0j}

/ Supported comparison operators for version rules given below, and mapped to a function
v.ops:.[!]flip(
  ("-","" ; {v.eq[x;y]}               );
  ("=","" ; {v.eq[x;y]}               );
  ("=="   ; {v.eq[x;y]}               );
  ("<="   ; {v.lt[x;y]|v.eq[x;y]}     );
  ("<","" ; {v.lt[x;y]}               );
  (">","" ; {not v.lt[x;y]|v.eq[x;y]} );
  (">="   ; {not v.lt[x;y]}           );
  ("~="   ; {not v.eq[x;y]}           );
  ("<>"   ; {not v.eq[x;y]}           );
  ("!="   ; {not v.eq[x;y]}           ));

/ @param  x   - [string] Version string typically of the form <major>.<minor>.<patch>
/ @param  y   - [string] Version rule, e.g. >=2.8 or <>1.4.2
/ @result     - [bool] If x satisfies the version rule, return true, false otherwise
v.comp:{value(v.ops r[0];x;last r:(0,(y in .Q.n)?1b)cut y)}

/ @param  pkgs  - [strings] List of package strings to be sorted in descending order by version
/ @result       - [long[]] Index that would arrange list of packages in descending order by version
v.sort:{exec j from update j:i@idesc"J"$"."vs'version by name from v.pkg@'x}

/ @param  name  - [string/symbol] Name of package
/ @result       - [dictionary] name and version of package if package name has that format
v.pkg:{[name]
  res:`name`version!(name:u.tostr name;"");
  if[not null i:first ss[name;"[",(last@'key v.ops),"][0-9]"];
    res:`name`version!(i#name;(i-:name[i-1]in(reverse@'key v.ops)[;1]except" ")_name)
    ];
  :@[res;`name;`$]
  }

/ @param  x     - [symbol/string] q object to string
/ @result       - [string] recursively
u.tostr:{$[10=t:type x;x;not t within 0 99;string x;.z.s@'x]}

pkg.isfile:{$[not any x like/:("*.[qk]";"*.[qk]_");0b;x~key x:hsym`$u.tostr x;1b;x~key x:.Q.dd[context.fp;`$1_string x]]}
pkg.ishdb:{$[not pkg.isdir x;0b;`par.txt in key x;1b;not null("DMJJ"i:10 7 4?count x0)$x0:string first key x]}
pkg.isdir:{$[pkg.isfile x;0b;pkg.ispkg x;0b;()~key x:hsym`$u.tostr x;not()~key .Q.dd[context.fp;`$1_string x];1b]}
pkg.ispkg:{0<count select from pkg.list[]where x like/:(string[name],'"*")}

/ @param  name  - [string/symbol] pkg name and version number in a string, e.g. "package-name-1.165.10"
/ @result       - [dictionary] name and version key value pairs.
pkg.info:{[name]
  res:`format`name`version!((pkg[`file`hdb`dir`pkg!`isfile`ishdb`isdir`ispkg]@\:name)?1b;`$u.tostr name;"");
  if[`pkg~res`format;
    res,:v.pkg name
    ];
  :res
  }

/ @param  dirs  - [symbols/null] List of directories for which to list the contents of. If empty or null, defaults to pkg.qpath
/ @result       - [table] with columns, pkg, dir, name, version. Sets result 
pkg.refresh:{[dirs]
  if[0=count res:res,'v.pkg@'exec pkg from res:{$[null[y]|()~d:key y;x;x,([]pkg:d;fp:.Q.dd'[y;d])]}/[([]pkg:`$();fp:`);dirs];
    :pkg.details:([]pkg:`$();fp:`$();name:`$();version:())
    ];
  res:update version:version inter\:(.Q.n,".")from res;
  :pkg.details:distinct pkg.details,:res
  }
pkg.list:{[]
  if[$[()~key res:.Q.dd[value"\\d";`pkg.details];1b;0=count value res];
    pkg.refresh pkg.qpath
    ];
  :pkg.details
  }

/ @param  name  - [dictsymbol/string] pkg name and version number in a string, e.g. "package-name-1.165.10",or in a dictionary with type,name and version keys
/ @result       - [dictionary] Details of best match for pkg string in available packages
pkg.find:{[name]
  if[$[99=type info:name;not`pkg~info`format;not`pkg~(info:pkg.info info)`format];
    $[not"/"~first fp:1_string hsym`$u.tostr info`name;
      info[`fp]:fp@:(()~/:key each fp:.Q.dd'[context.fp,`:.;`$fp])?0b;
      info[`fp]:hsym`$fp
      ];
    :info
    ];
  res:update format:`pkg from select from pkg.list[]where name=info`name;
  res:update valid:{$[0=count y;1b;all x v.comp\:/:csv vs y]}[version;info`version]from res;
  if[0=count res:delete valid from select from res where valid;
    '"No matching package found for ",.j.j info
    ];
  :res@first v.sort res`version
  }

/ @param  name  - [dictionary/symbol/string] pkg name and version number in a string, e.g. "package-name-1.165.10", or dictionary with package details
/ @result       - [table] Finds and loads package from QPATH, returning a table with details of the files loaded
pkg.load:{[name]
  / Set initial conditions
  ic:`pkg`fp#context;
  res:$[99=type name;name;pkg.find name];
  l:.[!]flip(
    (`file  ;pkg.l.file  );
    (`hdb   ;pkg.l.file  );
    (`pkg   ;pkg.l.pkg   );
    (`dir   ;pkg.l.dir   ));
  l[`]:{'"Unrecognised file or package: ",u.tostr$[99=type x;x;v.pkg x]`name};
  l[res`format][res];
  / reset initial conditions
  context,:ic;
  }
/ @param  name  - [dict/string/symbol] Name of file to load. Or dictionary with file details, including fp key specifying filepath
/ @result       - [void] Loads file if it exists, errors otherwise. File details added to files global
pkg.l.file:{[name]
  / Set package context
  pkg:context.pkg;
  if[()~key res[`fp]:hsym`$u.tostr(res:$[99=type name;name;pkg.find name])`fp;
    '"No such file or directory: ",1_string res`fp
    ];
  value"\\l ",1_string res`fp;
  res:update pkg from res;
  files,:select fp,pkg from res;
  :res
  }

/ List of supported subdirectories to load from (in order of preference) if <pkgname> does not exist
pkg.subdirs:`src`q`k;

/ @param  name  - [dict/string/symbol] Name of package to load. Or dictionary with package details, including fp key specifying filepath
/ @result       - [void] Loads init.q (if it exists) OR *.q/ *.k files from first of src, <pkgname> or q subdirectory found in package filepath. package details added to packages global
pkg.l.pkg:{[name]
  / Set parent package context
  ppkg:context.pkg;
  if[not`pkg~(res:$[99=type name;name;pkg.find name])`format;
    '"Could not find package: ",u.tostr res`name
    ];
  / Find subdirectory in order of preference, <pkgname>, src, q or k
  if[null subdir:first(res[`name],pkg.subdirs)inter key res`fp;
    if[not any key[res`fp]like/:("*.[qk]";"*.[qk]_");
      '"Unexpected package structure in ",name,". Expect either a ",res[`name]," src, q or k subdirectory (in that order of preference) or top-level *.[qk] files"
      ]
    ];
  context.switch res:update ppkg,pkgdir:fp,fp:.Q.dd[res`fp;subdir]from res; 
  packages,:1!select pkg,name,version,fp:pkgdir,ppkg from pkg.l.dir update format:`dir from res;
  :res
  }

/ @param  name  - [dict/string/symbol] Name of directory to load. Or dictionary with fp key specifying filepath of directory to load
/ @result       - [void] loads any *.q or *.k files found in directory specified, *will not recursively load from subdirectories to keep constraints on file structure* 
pkg.l.dir:{[name]
  if[()~key res[`fp]:hsym`$u.tostr(res:$[99=type name;name;pkg.find name])`fp;
    '"No such file or directory: ",1_string res`fp
    ];
  if[0=count fp:.Q.dd[res`fp]@'fp@:where any(fp:key res`fp)like/:("*.[qk]";"*.[qk]_");
    '"No files found in ",1_string res`fp
    ];
  if[any i:fp like"*/init.[qk]*";
    fp@:where i
    ];
  :pkg.l.file@'res,/:([]fp;format:`file)
  }

init:{[]
  context.switch[];
  pkg.qpath::$[0<count qpath:getenv`QPATH;hsym`$":"vs qpath;`:.]
  }
init[];

/ Shortcut
.q.import:{@[x .`pkg`load;y;{'x}]}value"\\d"
