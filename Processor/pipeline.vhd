----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Valentin Chatelard
-- 
-- Create Date:    10:15:28 04/08/2016 
-- Design Name: 
-- Module Name:    pipeline - Behavioral 
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
use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pipeline is
	generic(	size_op:	integer:=4);
    Port ( in_a : in  STD_LOGIC_VECTOR (size_op-1 downto 0);
           in_op : in  STD_LOGIC_VECTOR (size_op-1 downto 0);
           in_b : in  STD_LOGIC_VECTOR (size_op-1 downto 0);
           in_c : in  STD_LOGIC_VECTOR (size_op-1 downto 0);
           out_a : out  STD_LOGIC_VECTOR (size_op-1 downto 0);
           out_op : out  STD_LOGIC_VECTOR (size_op-1 downto 0);
           out_b : out  STD_LOGIC_VECTOR (size_op-1 downto 0);
           out_c : out  STD_LOGIC_VECTOR (size_op-1 downto 0);
			  ck : in STD_LOGIC);
end pipeline;

architecture Behavioral of pipeline is

begin
	process begin
		wait until ck'event and ck='1';
			out_a <= in_a;
			out_op <= in_op;
			out_b <= in_b;
			out_c <= in_c;
	end process;
end Behavioral;

