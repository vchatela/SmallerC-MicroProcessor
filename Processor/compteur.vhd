----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Valentin Chatelard
-- 
-- Create Date:    09:11:27 03/16/2016 
-- Design Name: 
-- Module Name:    compteur - Behavioral 
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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity compteur is
	generic(	width:	integer:=16);
	
	Port ( CK : in  STD_LOGIC;
           RST : in  STD_LOGIC;
           SENS : in  STD_LOGIC;
           LOAD : in  STD_LOGIC;
           EN : in  STD_LOGIC;
           Din : in  STD_LOGIC_VECTOR (width-1 downto 0);
           Dout : out  STD_LOGIC_VECTOR (width-1 downto 0));
end compteur;

architecture Behavioral of compteur is

signal Compteur : STD_LOGIC_VECTOR (width-1 downto 0);

begin

	process begin
	
		wait until CK'event and CK='1';
			if (RST='1') then
				Compteur<=(OTHERS => '0'); -- Compteur <= "00000000";
			else
				if (LOAD='1') then
					Compteur<=Din;
				elsif (EN='0') then
						if (SENS='0') then
							Compteur<=Compteur-1;
						else
							Compteur<=Compteur+1;
						end if;
				end if;
			end if; 

	end process;
	
	Dout <= Compteur;

end Behavioral;
