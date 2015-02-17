type pos = int
type lexresult = Tokens.token

val lineNum = ErrorMsg.lineNum
val linePos = ErrorMsg.linePos

val str = ref ""
val strPos  = ref 0; 
val commentCount  = ref 0;
val uncloseStr = ref false

fun err(p1,p2) = ErrorMsg.error p1

fun eof() = let val pos = hd(!linePos) in 
	if !commentCount > 0 
		then (ErrorMsg.error pos ("unclosed comments "); commentCount := 0; Tokens.EOF(pos,pos))
	else Tokens.EOF(pos,pos) end

%% 
%s STRING; 
%s COMMENT; 
%s ESCAPE; 
digit = [0-9];
letter = [A-Za-z];
%%
<INITIAL>\n	=> (lineNum := !lineNum+1; linePos := yypos :: !linePos; continue());
<INITIAL>","	=> (Tokens.COMMA(yypos,yypos+1));
<INITIAL>":"	=> (Tokens.COLON(yypos,yypos+1));
<INITIAL>";"	=> (Tokens.SEMICOLON(yypos,yypos+1));
<INITIAL>"("	=> (Tokens.LPAREN(yypos,yypos+1));
<INITIAL>")"	=> (Tokens.RPAREN(yypos,yypos+1));
<INITIAL>"["	=> (Tokens.LBRACK(yypos,yypos+1));
<INITIAL>"]"	=> (Tokens.RBRACK(yypos,yypos+1));
<INITIAL>"{"	=> (Tokens.LBRACE(yypos,yypos+1));
<INITIAL>"}"	=> (Tokens.RBRACE(yypos,yypos+1));
<INITIAL>"."	=> (Tokens.DOT(yypos,yypos+1));
<INITIAL>"+"	=> (Tokens.PLUS(yypos,yypos+1));
<INITIAL>"-"	=> (Tokens.MINUS(yypos,yypos+1));
<INITIAL>"*"	=> (Tokens.TIMES(yypos,yypos+1));
<INITIAL>"/"	=> (Tokens.DIVIDE(yypos,yypos+1));
<INITIAL>"<"	=> (Tokens.LT(yypos,yypos+1));
<INITIAL>">"	=> (Tokens.GT(yypos,yypos+1));
<INITIAL>"&"	=> (Tokens.AND(yypos,yypos+1));
<INITIAL>"|"	=> (Tokens.OR(yypos,yypos+1));
<INITIAL>"="	=> (Tokens.EQ(yypos,yypos+1));
<INITIAL>"<>"	=> (Tokens.NEQ(yypos,yypos+1));
<INITIAL>"<="	=> (Tokens.LE(yypos,yypos+1));
<INITIAL>">="	=> (Tokens.GE(yypos,yypos+1));
<INITIAL>":="	=> (Tokens.ASSIGN(yypos,yypos+1));
<INITIAL>" "    => (continue());

<INITIAL>while  => (Tokens.WHILE(yypos,yypos+5));
<INITIAL>let  	=> (Tokens.LET(yypos,yypos+3));
<INITIAL>in  	=> (Tokens.IN(yypos,yypos+2));
<INITIAL>end  	=> (Tokens.END(yypos,yypos+3));
<INITIAL>type  	=> (Tokens.TYPE(yypos,yypos+4));
<INITIAL>array  => (Tokens.ARRAY(yypos,yypos+5));
<INITIAL>if  	=> (Tokens.IF(yypos,yypos+2));
<INITIAL>then  	=> (Tokens.THEN(yypos,yypos+4));
<INITIAL>else  	=> (Tokens.ELSE(yypos,yypos+4));
<INITIAL>do  	=> (Tokens.DO(yypos,yypos+2));
<INITIAL>of  	=> (Tokens.OF(yypos,yypos+2));
<INITIAL>nil  	=> (Tokens.NIL(yypos,yypos+3));
<INITIAL>break  => (Tokens.BREAK(yypos,yypos+5));
<INITIAL>for  	=> (Tokens.FOR(yypos,yypos+3));
<INITIAL>var  	=> (Tokens.VAR(yypos,yypos+3));
<INITIAL>to  	=> (Tokens.TO(yypos,yypos+2));
<INITIAL>function  	=> (Tokens.FUNCTION(yypos,yypos+8));

<INITIAL>{letter}({letter}|_|{digit})* => (Tokens.ID(yytext, yypos, yypos+size(yytext)));
<INITIAL>{digit}+=> (Tokens.INT(valOf (Int.fromString(yytext)),yypos,yypos+size(yytext)));

<INITIAL>"\""		=> (YYBEGIN STRING; str := ""; strPos := yypos; uncloseStr := true; continue());
<STRING>\"    		=> (YYBEGIN INITIAL; uncloseStr := false; Tokens.STRING(!str, !strPos, yypos+1));
<STRING>\\(n|t|\^c|[0-9]{3}|\"|\\)	=> (str := !str ^ valOf(String.fromString yytext); continue());
<STRING>[\\]   		=> (YYBEGIN ESCAPE; continue());
<ESCAPE>[\n]  		=> (lineNum := !lineNum+1; linePos := yypos+1 :: !linePos; continue());
<ESCAPE>[\ \t\n\f]	=> (continue()); 
<ESCAPE>[\\]		=> (YYBEGIN STRING; continue());
<ESCAPE>.    		=> (ErrorMsg.error yypos ("Illegal escape character: " ^ yytext); YYBEGIN STRING; continue());
<STRING>[\n] 		=> (lineNum := !lineNum+1; linePos := yypos+1 :: !linePos; ErrorMsg.error yypos ("illegal linebreak in string literal "); continue());
<STRING>.      		=> (str := !str ^ yytext; continue());

<INITIAL>"/*" 	=> (YYBEGIN COMMENT; commentCount := !commentCount+1; continue()); 
<COMMENT>"/*" 	=> (commentCount := !commentCount + 1; continue()); 
<COMMENT>"*/" 	=> (commentCount := !commentCount - 1; continue()); 
<COMMENT>[\n] 	=> (lineNum := !lineNum+1; linePos := yypos+1 :: !linePos; continue());
<COMMENT>. 		=> (continue()) ;

<INITIAL>.       => (ErrorMsg.error yypos ("illegal character " ^ yytext); continue());










