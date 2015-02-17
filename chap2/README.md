The reserved words of the language are: 
..*		while, for, to, break, let, in, end, function, var, type, array, if, then, else, do, of, nil.

The punctuation symbols used in the language are: 
1. , : ; ( ) [ ] { } . + - * / = <> < <+ >+ & | :=

The string value that I'm returning for a string literal have the following escape sequences translated into their meanings. 

*escapes* 

*comments*

To detect unclosed comments (at the end of file) I'm using a variable to count how many comments are open and if they have their corresponding close set of characters (+1 when I see a [/*] and -1 if it is a [*/]). If the variable (commentCount) is greater than zero means there's an unclosed comment.

*strings* 

I totally underestimate this homework, specifically strings. I'm using a boolean variable (uncloseStr) and I initialize it to *true* when I find a ["] indicating a open string and move it to another state <STRING>. If I find another ["] inside the <STRING> state means I have to set (uncloseStr) to *false*. 

*end of file*

At the end of file, I check the values of the variables (uncloseStr) and (commentCount) to take decisions over what I should return. If the variable (commentCount) is greater than zero means there's an unclosed comment somewhere so I return an error and then return the EOF token. If the variable (uncloseStr) is *true* means there's an unclose string so I return an error indicating it and then return the EOF token. 
