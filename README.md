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
Different components :
- 8 bits Compter
- Instruction memory
- Data memory
- Direct memory access
- Arithmetic and Logic Unity (ALU)
- Data path
- Control Unity
- Unity of detection of contingencies
- 5 stages pipeline artchitecture

#Compiler Usage 
You must have `flex` and `bison`
```
valentinc@valentinc:~$ flex --version
flex 2.5.39
valentinc@valentinc:~$ bison --version 
bison (GNU Bison) 3.0.2
Écrit par Robert Corbett et Richard Stallman.

Copyright © 2013 Free Software Foundation, Inc.
Ce logiciel est libre; voir les sources pour les conditions de
reproduction. AUCUNE garantie n'est donnée; tant pour des raisons
COMMERCIALES que pour RÉPONDRE À UN BESOIN PARTICULIER.
```
To compile it, you only need to :
``` valentinc@valentinc:~/C_Compiler-VHDL/Compiler$ make ```

You can use it :
```
valentinc@valentinc:~/C_Compiler-VHDL/Compiler$ ./compiler 
reading file 'Tests/test_correct.c'
       |....+....:....+....:....+....:....+....:....+....:....+....:....+....:
     1 |
     2 |int f(){
     3 |  if(0==0){
     4 |    return 4;
     5 |  }
     6 |   return -1;
     7 |}
     8 |
     9 |int f(int args){
    10 |
    11 |}
    12 |
    13 |int main(){
    14 |	int a = 2,b, *c, *d = &c;
    15 |	int tab[12];
    16 |	b = 14;
    17 |	*c = a;
    18 |	tab[3] = -19;
    19 |	print(*c);
    20 |	print(*d);
    21 |	if(a==14 || b ==2){
    22 |	 f(1); 
    23 |	}
    24 |	else{
    25 |	  a = b +3;
    26 |	}
    27 |	if(a == 17 && b == 14){
    28 |	  a = b - 3;
    29 |	  print(tab[3]);
    30 |	}
    31 |	print(a);
    32 |	return 0;
    33 |}
```
By default that's 'Tests/test_correct.c' which is used by you can choose another one 
```
valentinc@valentinc:~/C_Compiler-VHDL/Compiler$ ./compiler Tests/test_incorrect.c
reading file 'Tests/test_incorrect.c'
       |....+....:....+....:....+....:....+....:....+....:....+....:....+....:
     1 |int f(){
     2 |	int a =2;
     3 |	int c,b=3;
     4 |	return a+b;
     5 |}
     6 |
     7 |int main(int a, int b){
...... !........^^^............   token9:11
Error: syntax error, unexpected tINT, expecting tPF
Process executed returning error(s)
```

#Interpreter Usage 
```
valentinc@valentinc:~/C_Compiler-VHDL/Interpreter$ make
yacc -Wconflicts-sr -d interpreteur_asm.yacc
mv y.tab.h interpreteur.h
flex interpreteur_asm.lex
gcc y.tab.c lex.yy.c interpreteur_asm.c gestion_instructions.c -ll -o interpreteur
valentinc@valentinc:~/C_Compiler-VHDL/Interpreter$ ./interpreteur < assembler.asm 
--  0. JMP  11 			{ Saut a la ligne 11 }
---------------------------------------------------------------
 11. AFC   1   2 
 12. COP   1   1 
 13. AFC   5   3 
 14. PCOPB   4   5 
 15. AFC  17  14 
 16. COP   2  17 
 17. COP  17   1 
 18. PCOPB   3  17 
 19. AFC  17  19 
 20. COP   8  17 
 21. PRI   3 			---> Valeur contenue a l'adresse   3 : 2
 22. PRI   4 			---> Valeur contenue a l'adresse   4 : 3
 23. COP  17   1 
 24. AFC  18  14 
 25. EQU  17  17  18 		{ 0 (@17) = 14(@18) ? 0(@17) }
 26. COP  18   2 
 27. AFC  19   2 
 28. EQU  18  18  19 		{ 0 (@18) = 2(@19) ? 0(@18) }
 29. OR  17  17  18 
 30. JMF  17  34 		{ La condition a l'adresse 17 est fausse, on saute a la ligne 34. }
---------------------------------------------------------------
 34. COP  17   2 
 35. AFC  18   3 
 36. ADD  17  17  18 
 37. COP   1  17 
 38. COP  17   1 
 39. AFC  18  17 
 40. EQU  17  17  18 		{ 1 (@17) = 17(@18) ? 1(@17) }
 41. COP  18   2 
 42. AFC  19  14 
 43. EQU  18  18  19 		{ 1 (@18) = 14(@19) ? 1(@18) }
 44. AND  17  17  18 
 45. JMF  17  51 		{ La condition a l'adresse 17 est vraie, on continue a la ligne 46. } 
 46. COP  17   2 
 47. AFC  18   3 
 48. SOU  17  17  18 
 49. COP   1  17 
 50. PRI   8 			---> Valeur contenue a l'adresse   8 : 19
 51. PRI   1 			---> Valeur contenue a l'adresse   1 : 11
 52. AFC  17   0 
 53. EXT  17 			 Process exited with code 0
 54. RET
 ```

#Processor execution (Xillinx)
 The following code executed on Xillinx 13.40
 ```
signal rom : rom_type:= (
        x"06051202",    -- AFC 0x5	0x12		R5 = 12
        x"05040502",    -- COP 0x4	0x5			R5 = R4 = 12
        x"05030402",    -- COP 0x3	0x4			R5 = R4 = R3 = 12
        x"01040504",    -- ADD 0x4	0x5 0x4 	R4 = 12 + 12 = 24 
        x"02030304",    -- MUL 0x3  0x3  0x4	R3 = 12 * 24 = 288
        x"06010002",    -- AFC 0x1  0x0			R1 = 0
        x"02010100",    -- MUL 0x1  0x0  0x0	R1 = 0*0  (Flag Z)
        x"0A0A0000",    -- JMZ 0xA				JMZ inst(09000000)
        x"ffffffff",x"ffffffff",              -- dust x2
        x"09000000",    -- JMP 0x0				JMP inst(06051202)
        x"aaffffff",x"bbffffff",x"ccffffff",  -- dust x3
        others=> x"00000000");
```
 ![Execution](http://s32.postimg.org/up9snmwxv/Capture.png)
 
