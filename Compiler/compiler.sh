cd ~/Bureau/C_Compiler-VHDL/Compiler
make -B
clean
echo -e "\n\n\n\n"
echo " #### Test incorrect : affectation sur const ### \n"
./compiler Tests/test_incorrect_const.c
read a
echo -e "\n\n\n\n"
echo " #### Test incorrect : paramètre du main ### \n"
./compiler Tests/test_incorrect.c
read a
echo -e "\n\n\n\n"
echo " #### Test correct ### \n"
./compiler
read a

echo -e "\n\n\n\n"
echo " #### Code resultant ### \n"
cat assembler.asm
cp assembler.asm ../Interpreter/assembler.asm
