--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   09:13:22 03/16/2016
-- Design Name:   
-- Module Name:   /home/murez/Bureau/compteur/test_compteur.vhd
-- Project Name:  compteur
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: compteur
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test_compteur IS
END test_compteur;
 
ARCHITECTURE behavior OF test_compteur IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT compteur
    PORT(
         CK : IN  std_logic;
         RST : IN  std_logic;
         SENS : IN  std_logic;
         LOAD : IN  std_logic;
         EN : IN  std_logic;
         Din : IN  std_logic_vector(7 downto 0);
         Dout : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CK : std_logic := '0';
   signal RST : std_logic := '0';
   signal SENS : std_logic := '0';
   signal LOAD : std_logic := '0';
   signal EN : std_logic := '0';
   signal Din : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal Dout : std_logic_vector(7 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: compteur PORT MAP (
          CK => CK,
          RST => RST,
          SENS => SENS,
          LOAD => LOAD,
          EN => EN,
          Din => Din,
          Dout => Dout
        );
	
		CK<=not CK after 10ns;
		EN<=not EN after 200ns;
		RST<=not RST after 600ns;
		LOAD<='1','0' after 20ns;
		Din<=X"AB";-- after 20ns;
		SENS<=not SENS after 500ns;

END;