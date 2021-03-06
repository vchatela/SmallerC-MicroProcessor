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
			  alea : in STD_LOGIC;
           Dout : out  STD_LOGIC_VECTOR(size_inst-1 downto 0));
end Mem_inst;

architecture Behavioral of Mem_inst is
type rom_type is array (0 to 2**width -1) of STD_LOGIC_VECTOR(size_inst-1 downto 0);

signal rom : rom_type:= (x"06051202",x"05040502",x"05030402",x"01040504",x"02030304",x"06010002",x"02010101",
x"0A0C0000",x"ffffffff",x"ffffffff",x"ffffffff",x"ffffffff",
x"09000000",x"aaffffff",x"bbffffff",x"ccffffff",
others=> x"00000000");
-- AFC 0x05	0x12				R5 = 12
-- COP 0x4	0x5				R5 = R4 = 12
-- COP 0x3	0x4				R5 = R4 = R3 = 12
-- ADD 0x4	0x05 	0x04 		R4 = 12 + 12 = 24 
-- MUL 0x3  0x3  	0x4		R3 = 12 * 24 = 288
-- AFC 0x1  0x0				R1 = 0
-- MUL 0x1  0x1  	0x1		R1 = 0*0  (Flag Z)
-- JMZ 0xC						JMZ inst(09000000)
-- dust x4
-- JMP 0x0						JMP inst(06051202)
-- dust x3

begin
	process begin
		wait until CK'event and CK='1';
			if(alea='0') then
				Dout <= rom(conv_integer(ADDR));
			end if;
	end process;

end Behavioral;

