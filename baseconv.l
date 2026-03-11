%option noyywrap
%option header-file="baseconv.l.h"

%%
[[:graph:]]+	{ return 0; }

[ \t\n]	{ /* ignore whitespace */ }
<<EOF>>	{ return -1; }
%%
