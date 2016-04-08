----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Valentin Chatelard
-- 
-- Create Date:    11:55:17 03/30/2016 
-- Design Name: 
-- Module Name:    Banc_registres - Behavioral 
-- Project Name: 
-- Target Devices: Spartan 6
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision:  08-04-2016
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;+-

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Banc_registres is
generic( width : integer:= 32; -- 4 octets d'adr => 32 bits 
				size_mem: integer:=8;
				addr_size : integer:=4); 

    Port ( ADD_A : in  STD_LOGIC_VECTOR (addr_size-1 downto 0);
           ADD_B : in  STD_LOGIC_VECTOR (addr_size-1 downto 0);
           ADD_W : in  STD_LOGIC_VECTOR (addr_size-1 downto 0);
           W : in  STD_LOGIC;
           DATA : in  STD_LOGIC_VECTOR (size_mem-1 downto 0);
           RST : in  STD_LOGIC;
           CK : in  STD_LOGIC;
           QA : out  STD_LOGIC_VECTOR (size_mem-1 downto 0);
           QB : out  STD_LOGIC_VECTOR (size_mem-1 downto 0));
end Banc_registres;

architecture Behavioral of Banc_registres is
type Type_Banc is array(0 to width-1) of std_logic_vector(size_mem-1 downto 0);
signal Banc : Type_Banc;

begin

	process begin
		wait until CK'event and CK='1';
			if RST='0' then
				Banc <= (others => (others=>'0'));
			else if RST='1' then
				if W='1' then
					-- écriture : 
					Banc(conv_integer(ADD_W)) <= DATA;
					if ADD_W = ADD_A then
						QA <= DATA;
					else 
						QA <= Banc(conv_integer(ADD_A));
					end if;
					
					if ADD_W = ADD_B then
						QA <= DATA;
					else 
						QA <= Banc(conv_integer(ADD_B));
					end if;	
			else if W='0' then
			-- lecture :
			QA <= Banc(conv_integer(ADD_A));
			QB <= Banc(conv_integer(ADD_B));
			end if;
		end if;
		end if;
		end if;
	end process;

end Behavioral;

