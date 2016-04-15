----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Valentin Chatelard
-- 
-- Create Date:    11:16:13 03/30/2016 
-- Design Name: 
-- Module Name:    Mem_inst - Behavioral 
-- Project Name: 
-- Target Devices: Spartan 6
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 08-04-2016
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;		 
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Mem_inst is
	generic(	width:	integer:=8;
				size_inst: 	integer:=32);
    Port ( ADDR : in  STD_LOGIC_VECTOR(width-1 downto 0);
           CK : in  STD_LOGIC;
           Dout : out  STD_LOGIC_VECTOR(size_inst-1 downto 0));
end Mem_inst;

architecture Behavioral of Mem_inst is
type rom_type is array (0 to 2**width -1) of STD_LOGIC_VECTOR(size_inst-1 downto 0);

signal rom : rom_type:= (x"06051202",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",x"050405FF",x"01040405",others=> x"00000000");
-- AFC 0x0 	0x1
-- AFC 0x5 	0x12
-- AFC 0xA 	0x58
-- AFC 0x3  0x56
-- COP 0xA	0x00
-- COP 0x0	0x05 
-- COP 0x5	0x03
-- ADD 0x2 	0x5  0x3
-- MUL 0x5  0x3  0xA
-- SUB 0x7  0x0  0x1 


begin
	process begin
		wait until CK'event and CK='1';
			Dout <= rom(conv_integer(ADDR));
	end process;

end Behavioral;

