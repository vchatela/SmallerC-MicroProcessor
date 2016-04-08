----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Valentin Chatelard
-- 
-- Create Date:    11:39:45 03/30/2016 
-- Design Name: 
-- Module Name:    ALU - Behavioral 
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
USE ieee.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
	generic(	width:	integer:=8
				--carry: std_logic_vector:=(
	);
    Port ( DinA : in  STD_LOGIC_VECTOR (width-1 downto 0);
           DinB : in  STD_LOGIC_VECTOR (width-1 downto 0);
           Ctrl_Alu : in  STD_LOGIC_VECTOR (2 downto 0);
           Dout : out  STD_LOGIC_VECTOR (width-1 downto 0);
           N : out  STD_LOGIC;
           O : out  STD_LOGIC;
           Z : out  STD_LOGIC;
           C : out  STD_LOGIC);
end ALU;

architecture Behavioral of ALU is

signal alu_tmp: std_logic_vector(2*width-1 downto 0);
signal n_tmp :  STD_LOGIC;
signal o_tmp :  STD_LOGIC;
signal z_tmp :  STD_LOGIC;
signal c_tmp :  STD_LOGIC;
signal over : std_logic_vector(width-1 downto 0);

begin
	over <= (others => '0');
	alu_tmp <= 	(over & DinA) + (over & DinB) when Ctrl_Alu = "001" else
					DinA * DinB when Ctrl_Alu = "010" else
					(over & DinA) - (over & DinB) when Ctrl_Alu = "011" else
					(others => 'X'); --maybe (others => '0');
					--(over & DinA) / (over & DinB) when Ctrl_Alu = "100" else
	n_tmp	<= alu_tmp(width - 1);
	o_tmp	<= '1' when Ctrl_Alu = "010" and alu_tmp(2*width-1 downto width) /= over else '0';
	z_tmp <= '1' when alu_tmp(2*width-1 downto width) = over else '0';
	c_tmp <= alu_tmp(width); 
	Dout <= alu_tmp(width - 1 downto 0);
end Behavioral;

