----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Valentin Chatelard
-- 
-- Create Date:    10:21:51 03/30/2016 
-- Design Name: 
-- Module Name:    Mem_donnee - Behavioral 
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

entity Mem_donnee is
	generic(	width:	integer:=8;
				depth: 	integer:=64);
		
    Port ( ADDR : in  STD_LOGIC_VECTOR (width-1 downto 0);
           Din : in  STD_LOGIC_VECTOR (width -1 downto 0);
           RW : in  STD_LOGIC;
           RST : in  STD_LOGIC;
           CK : in  STD_LOGIC;
           Dout : out  STD_LOGIC_VECTOR (width-1 downto 0));
end Mem_donnee;

architecture Behavioral of Mem_donnee is

type ram_type is array (0 to depth-1) of 
	std_logic_vector(width-1 downto 0);
	
signal tmp_ram: ram_type;

begin
	process begin
		wait until CK'event and CK='1';
			if (RST='1') then
				tmp_ram <= (OTHERS => (others => '0'));
			else
				if (RW='1') then
					Dout <= tmp_ram(conv_integer(ADDR));
				else
					tmp_ram(conv_integer(ADDR)) <= Din;
				end if;
			end if; 
	end process;
end Behavioral;

