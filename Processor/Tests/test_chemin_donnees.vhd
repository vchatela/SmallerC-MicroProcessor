--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:20:01 04/11/2016
-- Design Name:   
-- Module Name:   /home/valentinc/Bureau/Projet Systeme Info - Archi/processeur/test_chemin_donnees.vhd
-- Project Name:  processeur
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: chemin_donnees
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
 
ENTITY test_chemin_donnees IS
END test_chemin_donnees;
 
ARCHITECTURE behavior OF test_chemin_donnees IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT chemin_donnees
    PORT(
         CK : IN  std_logic;
         RST : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CK : std_logic := '0';
   signal RST : std_logic := '0';
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant CK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: chemin_donnees PORT MAP (
          CK => CK,
          RST => RST
        );

   -- Clock process definitions
   CK_process :process
   begin
		CK <= '0';
		wait for CK_period/2;
		CK <= '1';
		wait for CK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
		RST <= '1';
      wait for 50 ns;	
		RST <='0';
      wait for CK_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
