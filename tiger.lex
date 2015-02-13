type pos = int
type lexresult = Tokens.token

val lineNum = ErrorMsg.lineNum
val linePos = ErrorMsg.linePos
fun err(p1,p2) = ErrorMsg.error p1

fun eof() = let val pos = hd(!linePos) in Tokens.EOF(pos,pos) end


%% 
digit = [0-9];
letter = [A-Za-z];
%%
\n	=> (lineNum := !lineNum+1; linePos := yypos :: !linePos; continue());
","	=> (Tokens.COMMA(yypos,yypos+1));
"="	=> (Tokens.EQ(yypos,yypos+1));
":"	=> (Tokens.COLON(yypos,yypos+1));
" "     => (continue());
var  	=> (Tokens.VAR(yypos,yypos+3));
type  	=> (Tokens.TYPE(yypos,yypos+4));
{letter}({letter}|_|{digit})* => (Tokens.ID(yytext, yypos, yypos+size(yytext)));
{digit}+	=> (Tokens.INT(valOf (Int.fromString(yytext)),yypos,yypos+size(yytext)));
.       => (ErrorMsg.error yypos ("illegal character " ^ yytext); continue());

