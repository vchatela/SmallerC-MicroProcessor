# Processor_Lexer_Yacc_Compiler_C

![Complete Schema](http://s21.postimg.org/46rwmfq0n/Capture.png)

# Language and Assembler
## Simplify C
The input language is a C-like language which recognize:
- functions and main
- only integer (at beginning)
- multiple declaration of const like `const int i, j=3,k;` (only in main)
- Basic arithmetic operations
- `printf(var)` whith var as a variable

## Assembler 
- **Addition** : `ADD @result @op1 @op2`
- **Multiplication** : `MUL @result @op1 @op2`
- **Substraction** : `SOU @result @op1 @op2`
- **Division** : `DIV @result @op1 @op2`
- **Copy** : `COP @result @op`
- **Affectation** : `AFC @result @op1 @op2`
- **Jump** : `JMP instruction_number`
- **Jump if false** : `JMF @X instruction_number`
- **Comparison** : `INF @result @op1 @op2` or `SUP @result @op1 @op2` or `EQU @result @op1 @op2`
- **Print** : `PRI result`


#Implementation
## Development of a simplify C Compiler using Lex and Yacc
- Application of automata and languages

## Conception of a RISC microprocessor with pipeline

