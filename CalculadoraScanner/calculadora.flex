import java.io.*;

%%
%class CalculadoraScanner
%unicode
%public
%standalone
%line
%column

%{
    private PrintWriter arquivo;

    private void escreverToken(String conteudo, String tipo) {
        arquivo.println("<" + tipo + ", \"" + conteudo + "\">");
    }

    private void escreverError(String conteudo) {
        arquivo.println("<ERRO, \"" + conteudo + "\", linha=" + (yyline+1) + ", posição=" + (yycolumn+1) + ">");
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
    if (arquivo != null) {
        arquivo.close();
        System.out.println("Tokens salvos em saida.txt");
    }
%eof}

%%

// OPERADORES
"**"    { escreverToken(yytext(), "POTÊNCIA"); }
"//"    { escreverToken(yytext(), "RESTO"); }
"/"     { escreverToken(yytext(), "DIVISÃO"); }
"+"     { escreverToken(yytext(), "MAIS"); }
"-"     { escreverToken(yytext(), "MENOS"); }
"*"     { escreverToken(yytext(), "VEZES"); }
"("     { escreverToken(yytext(), "A-PAREN"); }
")"     { escreverToken(yytext(), "F-PAREN"); }

// NÚMEROS
[0-9]+                { escreverToken(yytext(), "INT"); }
[0-9]+\.[0-9]+        { escreverToken(yytext(), "FLOAT"); }

// ESPAÇOS
[ \t\r\n\f]+          { /* ignora */ }

// ERRO
.       { escreverError(yytext()); }
