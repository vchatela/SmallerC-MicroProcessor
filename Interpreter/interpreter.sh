cd ~/Bureau/C_Compiler-VHDL/Interpreter
make -B
clean
echo -e "\n\n\n\n"
echo "Ouvrez le code C correspondant : test_correct.c"
read a
./interpreteur < assembler.asm 
