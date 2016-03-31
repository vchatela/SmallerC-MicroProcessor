# Processor_Lexer_Yacc_Compiler_C

![Complete Schema](http://s21.postimg.org/46rwmfq0n/Capture.png)

# Language and Assembler
## Simplify C
The input language is a C-like language which recognize:
- functions and main
- only integer
- multiple declaration of const like `const int i, j=3,k;` (only in main)
- Basic arithmetic operations
- `printf(var)` whith var as a variable
- if/else while
- tabulars
- pointers

## Assembler 
- **Addition** : `ADD @result @op1 @op2`
- **Multiplication** : `MUL @result @op1 @op2`
- **Substraction** : `SOU @result @op1 @op2`
- **Division** : `DIV @result @op1 @op2`
- **Copy** : `COP @result @op`
- **Affectation** : `AFC @result @op1 @op2`
- **Jump** : `JMP instruction_number`
- **Jump if false** : `JMF @X instruction_number`
- **Comparison** : `INF(EQ) @result @op1 @op2` or `SUP(EQ) @result @op1 @op2` or `EQU @result @op1 @op2`
- **Print** : `PRI result`
- **Pointer1** : `PCOPA @pointedvalue @pointer `
- **Pointer2** : `PCOPB @pointer @pointedvalue`
- **Call function** : `CALL @jump `
- **End function** : `RET`
- **Return** : `EXT @val`
- **Nothing** : `NOP`
- **And** : `AND @result @op1 @op2`
- **Or** : `OR @result @op1 @op2`

#Implementation
## Development of a simplify C Compiler using Lex and Yacc
- Lexer to find tokens
- Type 2 Grammar for C (using table of labels, functions, symbols)
- Upgrade : show line and token when error

## Conception of a RISC microprocessor with pipeline using VHDL and Spartan 6
Differents components :
- 16 bits Compter
- Instruction memory
- Data memory
- Direct memory access
- Arithmetic and Logic Unity (ALU)
- Data path
- Control Unity
- Unity of detection of contingencies
- 5 stages pipeline artchitecture