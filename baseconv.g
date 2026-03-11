args	"-F baseconv -c g.c -H g.h -uNUMBER --func-name ggo --show-required --default-optional --no-help --no-version -G"

package "baseconv"
version "1.0.0"

usage "Usage: baseconv -iIBASE -oOBASE [NUMBER]..."
description	"Convert integer numbers from IBASE to OBASE.\nIf no NUMBERs, read from standard input.\n\nValid bases are those supported by GNU GMP, [2, 62]; [-32, -2] are supported for output only."

section "Options"
option	"input-base" i "Use input base IBASE" int typestr="IBASE" default="-1"
option	"output-base" o "Use output base OBASE" int typestr="OBASE" default="-1"
option	"loose-exit-status" l "Exit with 0 even if invalid input encountered"
option	"quiet" q "Don't print NUMBER in the original base before output"
option	"silent" s "Don't print error messages"
section	"Getting help"
option	"help" h "Print this help message and exit"
option	"version" v "Print version information and exit"
text	"\nTry 'man baseconv' for more information."

versiontext	"Copyright (C) 2026 Jack Renton Uteg.\nLicense GPLv3+: GNU GPL version 3 or later <https://gnu.org/licenses/gpl.html>.\nThis is free software: you are free to change and redistribute it.\nThere is NO WARRANTY, to the extent permitted by law.\n\nWritten by Jack R. Uteg."
