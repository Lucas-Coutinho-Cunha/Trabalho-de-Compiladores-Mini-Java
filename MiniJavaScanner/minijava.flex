import java.io.*;

%%

%class MiniJavaScanner
%unicode
%public
%standalone
%line
%column

%{
    private PrintWriter arquivo;

    private void escreverToken(String tipo, String conteudo) {
        arquivo.println("<" + tipo + ", \"" + conteudo + "\">");
    }

    private void escreverError(String conteudo) {
        arquivo.println("<ERROR, \"" + conteudo + "\", linha=" + (yyline + 1) + ", coluna=" + (yycolumn + 1) + ">");
    }
%}

%init{
    try {
        arquivo = new PrintWriter(new FileWriter("saida.txt"));
    } catch (IOException e) {
        throw new RuntimeException("Erro ao abrir arquivo de saída", e);
    }
%init}

%eof{    
	if (yystate() == IN_COMMENT) {
        escreverError("Comentario de bloco nao fechado");
    }
    if (arquivo != null) {
        arquivo.close();
        System.out.println("Tokens salvos em saida.txt");
    }
%eof}

%state IN_COMMENT

%%

// ---------- PALAVRAS-RESERVADAS ----------
"class"             { escreverToken("CLASS", yytext()); }
"public"            { escreverToken("PUBLIC", yytext()); }
"static"            { escreverToken("STATIC", yytext()); }
"void"              { escreverToken("VOID", yytext()); }
"main"              { escreverToken("MAIN", yytext()); }
"String"            { escreverToken("STRING", yytext()); }
"extends"           { escreverToken("EXTENDS", yytext()); }
"return"            { escreverToken("RETURN", yytext()); }
"int"               { escreverToken("INT", yytext()); }
"boolean"           { escreverToken("BOOLEAN", yytext()); }
"if"                { escreverToken("IF", yytext()); }
"else"              { escreverToken("ELSE", yytext()); }
"while"             { escreverToken("WHILE", yytext()); }
"System.out.println" { escreverToken("PRINT", yytext()); }
"true"              { escreverToken("TRUE", yytext()); }
"false"             { escreverToken("FALSE", yytext()); }
"this"              { escreverToken("THIS", yytext()); }
"new"               { escreverToken("NEW", yytext()); }
"length"            { escreverToken("LENGTH", yytext()); }

// ---------- OPERADORES E SÍMBOLOS ----------
"="                 { escreverToken("ATRIB", yytext()); }
"=="                { escreverToken("IGUAL", yytext()); }
"!="                { escreverToken("DIFERENTE", yytext()); }
"<="                { escreverToken("MENOR-IGUAL", yytext()); }
"<"                 { escreverToken("MENORQ", yytext()); }
"&&"                { escreverToken("E", yytext()); }
"||"                { escreverToken("OU", yytext()); }
"+"                 { escreverToken("MAIS", yytext()); }
"-"                 { escreverToken("MENOS", yytext()); }
"*"                 { escreverToken("VEZES", yytext()); }
"/"                 { escreverToken("DIV", yytext()); }
"%"                 { escreverToken("MOD", yytext()); }
"!"                 { escreverToken("NEGACAO", yytext()); }
"{"                 { escreverToken("A-CHAVE", yytext()); }
"}"                 { escreverToken("F-CHAVE", yytext()); }
"("                 { escreverToken("A-PAREN", yytext()); }
")"                 { escreverToken("F-PAREN", yytext()); }
"["                 { escreverToken("A-COLC", yytext()); }
"]"                 { escreverToken("F-COLC", yytext()); }
";"                 { escreverToken("PONTO-VIRGULA", yytext()); }
"."                 { escreverToken("PONTO", yytext()); }

// ---------- IDENTIFICADORES E NÚMEROS ----------
[0-9]+              { escreverToken("NUM", yytext()); }
[a-zA-Z][a-zA-Z0-9_]* { escreverToken("ID", yytext());}

// ---------- STRINGS ----------
\"([^\"\\\n]|\\.)*\"   { escreverToken("TEXTO", yytext()); }

\"([^\"\\\n]|\\.)*     { escreverError("String não fechada: " + yytext()); }

// ---------- ESPAÇOS E COMENTÁRIOS ----------
[ \t\r\n\f]+        { /* ignora */ }
"//" [^\n]*         { /* ignora */ }
"/*"                { yybegin(IN_COMMENT); }

<IN_COMMENT> {
    "*/"            { yybegin(YYINITIAL); }
    [^*]+           { /* ignora */ }
    "*"             { /* ignora */ }
}

// ---------- ERROS ----------
. { escreverError(yytext()); }
