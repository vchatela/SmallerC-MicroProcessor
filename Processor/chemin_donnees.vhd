----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Valentin Chatelard
-- 
-- Create Date:    10:40:06 04/06/2016 
-- Design Name: 
-- Module Name:    chemin_donnees - Behavioral 
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

entity chemin_donnees is
generic( 
	width_ALU:	integer:=16;
	-- USELESS : INSIDE BR.VHDL ONLY 	width_BR : integer:= 32; -- 4 octets d'adr => 32 bits 
	size_men_BR: integer:=8;
	addr_size_BR: integer:=4;
	width_MD:	integer:=16;
	depth_MD: 	integer:=64;
	width_MI:	integer:=2**16; --2^16 plutot
	size_inst_MI: 	integer:=32;
	width_C:	integer:=16;
	size_op: integer:=8 -- size_inst_MI/4
);
	port(	
		-- ALU --
	  DinA : in  STD_LOGIC_VECTOR (width_ALU-1 downto 0);
	  DinB : in  STD_LOGIC_VECTOR (width_ALU-1 downto 0);
	  Ctrl_Alu : in  STD_LOGIC_VECTOR (2 downto 0);
	  DoutA : out  STD_LOGIC_VECTOR (width_ALU-1 downto 0);
	  N : out  STD_LOGIC;
	  O : out  STD_LOGIC;
	  Z : out  STD_LOGIC;
	  C : out  STD_LOGIC;
	  
	  -- Banc Registre --
	  ADD_A : in  STD_LOGIC_VECTOR (3 downto 0);
	  ADD_B : in  STD_LOGIC_VECTOR (3 downto 0);
	  ADD_W : in  STD_LOGIC_VECTOR (3 downto 0);
	  W : in  STD_LOGIC;
	  DATA : in  STD_LOGIC_VECTOR (size_men_BR-1 downto 0);
	  RST_BR : in  STD_LOGIC;
			--CK : in  STD_LOGIC;
	  QA : out  STD_LOGIC_VECTOR (size_men_BR-1 downto 0);
	  QB : out  STD_LOGIC_VECTOR (size_men_BR-1 downto 0);
	  
	  -- Memoire Donnee --
	  ADDR_MD : in  STD_LOGIC_VECTOR (width_MD-1 downto 0);
	  Din : in  STD_LOGIC_VECTOR (width_MD -1 downto 0);
	  RW : in  STD_LOGIC;
	  RST_MD : in  STD_LOGIC;
			--CK : in  STD_LOGIC;
	  DoutD : out  STD_LOGIC_VECTOR (width_MD-1 downto 0);
	  
	  -- Memoire Instruction --
	  ADDR_MI : in  STD_LOGIC_VECTOR(width_MI-1 downto 0);
			--CK : in  STD_LOGIC;
	  DoutMI : out  STD_LOGIC_VECTOR(size_inst_MI-1 downto 0);
	  
	  -- Compteur --
	  CK : in  STD_LOGIC;
	  RST : in  STD_LOGIC;
	  SENS : in  STD_LOGIC;
	  LOAD : in  STD_LOGIC;
	  EN : in  STD_LOGIC;
	  DinC : in  STD_LOGIC_VECTOR (width_C-1 downto 0);
	  DoutC : out  STD_LOGIC_VECTOR (width_C-1 downto 0)
	  
);
end chemin_donnees;

architecture Behavioral of chemin_donnees is

	component ALU is 
	generic( 
		width:	integer:=16
	);
	port(
	  DinA : in  STD_LOGIC_VECTOR (width-1 downto 0);
	  DinB : in  STD_LOGIC_VECTOR (width-1 downto 0);
	  Ctrl_Alu : in  STD_LOGIC_VECTOR (2 downto 0);
	  Dout : out  STD_LOGIC_VECTOR (width-1 downto 0);
	  N : out  STD_LOGIC;
	  O : out  STD_LOGIC;
	  Z : out  STD_LOGIC;
	  C : out  STD_LOGIC
	);
	end component;

	component Banc_registres is
	generic( width : integer:= 32; -- 4 octets d'adr => 32 bits 
					size_inst: integer:=8;
					addr_size_BR : integer:=4); 

	Port ( ADD_A : in  STD_LOGIC_VECTOR (addr_size_BR-1 downto 0);
				  ADD_B : in  STD_LOGIC_VECTOR (addr_size_BR-1 downto 0);
				  ADD_W : in  STD_LOGIC_VECTOR (addr_size_BR-1 downto 0);
				  W : in  STD_LOGIC;
				  DATA : in  STD_LOGIC_VECTOR (size_inst-1 downto 0);
				  RST : in  STD_LOGIC;
				  CK : in  STD_LOGIC;
				  QA : out  STD_LOGIC_VECTOR (size_inst-1 downto 0);
				  QB : out  STD_LOGIC_VECTOR (size_inst-1 downto 0));
	end component;

	component Mem_donnee is
		generic(	width:	integer:=16;
					depth: 	integer:=64);
			
		 Port ( ADDR : in  STD_LOGIC_VECTOR (width-1 downto 0);
				  Din : in  STD_LOGIC_VECTOR (width -1 downto 0);
				  RW : in  STD_LOGIC;
				  RST : in  STD_LOGIC;
				  CK : in  STD_LOGIC;
				  Dout : out  STD_LOGIC_VECTOR (width-1 downto 0));
	end component;

	component Mem_inst is
		generic(	width:	integer:=2**16; --2^16 plutot
					size_inst: 	integer:=32);
		 Port ( ADDR : in  STD_LOGIC_VECTOR(width-1 downto 0);
				  CK : in  STD_LOGIC;
				  Dout : out  STD_LOGIC_VECTOR(size_inst-1 downto 0));
	end component;

	component compteur is
		generic(	width:	integer:=16);
		
		Port ( CK : in  STD_LOGIC;
				  RST : in  STD_LOGIC;
				  SENS : in  STD_LOGIC;
				  LOAD : in  STD_LOGIC;
				  EN : in  STD_LOGIC;
				  Din : in  STD_LOGIC_VECTOR (width-1 downto 0);
				  Dout : out  STD_LOGIC_VECTOR (width-1 downto 0));
	end component;
	
	component pipeline is
	generic(	size_op:	integer:=8);
    Port ( in_a : in  STD_LOGIC_VECTOR (size_op-1 downto 0);
           in_op : in  STD_LOGIC_VECTOR (size_op-1 downto 0);
           in_b : in  STD_LOGIC_VECTOR (size_op-1 downto 0);
           in_c : in  STD_LOGIC_VECTOR (size_op-1 downto 0);
           out_a : out  STD_LOGIC_VECTOR (size_op-1 downto 0);
           out_op : out  STD_LOGIC_VECTOR (size_op-1 downto 0);
           out_b : out  STD_LOGIC_VECTOR (size_op-1 downto 0);
           out_c : out  STD_LOGIC_VECTOR (size_op-1 downto 0);
			  ck : in STD_LOGIC);
	end component;
	
	-- LI 2 DI --
	signal in_li_di_a : STD_LOGIC_VECTOR (size_op-1 downto 0);
	signal in_li_di_op : STD_LOGIC_VECTOR (size_op-1 downto 0);
	signal in_li_di_b : STD_LOGIC_VECTOR (size_op-1 downto 0);
	signal in_li_di_c : STD_LOGIC_VECTOR (size_op-1 downto 0);
	signal out_li_di_a : STD_LOGIC_VECTOR (size_op-1 downto 0);
	signal out_li_di_op : STD_LOGIC_VECTOR (size_op-1 downto 0);
	signal out_li_di_b : STD_LOGIC_VECTOR (size_op-1 downto 0);
	signal out_li_di_c : STD_LOGIC_VECTOR (size_op-1 downto 0);
	-- DI 2 EX --
	signal in_di_ex_a : STD_LOGIC_VECTOR (size_op-1 downto 0);
	signal in_di_ex_op : STD_LOGIC_VECTOR (size_op-1 downto 0);
	signal in_di_ex_b : STD_LOGIC_VECTOR (size_op-1 downto 0);
	signal out_di_ex_a : STD_LOGIC_VECTOR (size_op-1 downto 0);
	signal out_di_ex_op : STD_LOGIC_VECTOR (size_op-1 downto 0);
	signal out_di_ex_b : STD_LOGIC_VECTOR (size_op-1 downto 0);
	-- EX 2 MEM --
	signal in_ex_mem_a : STD_LOGIC_VECTOR (size_op-1 downto 0);
	signal in_ex_mem_op : STD_LOGIC_VECTOR (size_op-1 downto 0);
	signal in_ex_mem_b : STD_LOGIC_VECTOR (size_op-1 downto 0);
	signal out_ex_mem_a : STD_LOGIC_VECTOR (size_op-1 downto 0);
	signal out_ex_mem_op : STD_LOGIC_VECTOR (size_op-1 downto 0);
	signal out_ex_mem_b : STD_LOGIC_VECTOR (size_op-1 downto 0);
	-- Mem 2 RE --
	signal in_mem_re_a : STD_LOGIC_VECTOR (size_op-1 downto 0);
	signal in_mem_re_op : STD_LOGIC_VECTOR (size_op-1 downto 0);
	signal in_mem_re_b : STD_LOGIC_VECTOR (size_op-1 downto 0);
	signal out_mem_re_a : STD_LOGIC_VECTOR (size_op-1 downto 0);
	signal out_mem_re_op : STD_LOGIC_VECTOR (size_op-1 downto 0);
	signal out_mem_re_b : STD_LOGIC_VECTOR (size_op-1 downto 0);
	
	-- ALU --
  signal out_alu :  STD_LOGIC_VECTOR (width_ALU-1 downto 0);
  signal out_N :  STD_LOGIC;
  signal out_O :  STD_LOGIC;
  signal out_Z :  STD_LOGIC;
  signal out_C :  STD_LOGIC;
  
  -- Banc Registre --
  signal out_QA :  STD_LOGIC_VECTOR (size_men_BR-1 downto 0);
  signal out_QB :  STD_LOGIC_VECTOR (size_men_BR-1 downto 0);
  
  -- Memoire Donnee --
  signal out_DoutD :  STD_LOGIC_VECTOR (width_MD-1 downto 0);
  
  -- Memoire Instruction --
  signal out_MI :  STD_LOGIC_VECTOR(size_inst_MI-1 downto 0);
	  
  -- Compteur --
  signal out_CP :  STD_LOGIC_VECTOR (width_C-1 downto 0);
	
begin	

	-- Instantiations --
	AL : ALU port map (DinA, DinB ,Ctrl_Alu, out_alu, out_N, out_O, out_Z, out_C);
	BR : Banc_registres port map (ADD_A, ADD_B , out_mem_re_a(addr_size_BR-1 downto 0), '1',out_mem_re_b, RST_BR, CK, out_QA,out_QB); -- DATA <= out_mem_re_b; W <= 1; -- AFC on écrit (W <= 1)  - ADD_W <= out_mem_re_a;
	MD : Mem_donnee port map ( ADDR_MD, Din, RW, RST_MD, CK, out_DoutD);
	MI : Mem_inst port map (ADDR_MI, CK, out_MI);
	CP : compteur port map (CK , RST , SENS, LOAD , EN , DinC , out_CP);
	
	-- Pipelines --
	in_li_di_a <= out_MI(size_op-1 downto 0);
	in_li_di_op <= out_MI(2*size_op-1 downto size_op);
	in_li_di_b <= out_MI(3*size_op-1 downto 2*size_op);
	in_li_di_c <= out_MI(4*size_op-1 downto 3*size_op);
	
	PLI2DI : pipeline port map(in_li_di_a,in_li_di_op,in_li_di_b,in_li_di_c, out_li_di_a, out_li_di_op, out_li_di_b, open, CK );
	PDI2EX : pipeline port map(out_li_di_a, out_li_di_op, out_li_di_b, (others=>'0') ,out_di_ex_a,out_di_ex_op,out_di_ex_b,open, CK );-- 0 for nothing (bidon)
	PEX2MEM : pipeline port map(out_di_ex_a,out_di_ex_op,out_di_ex_b,(others=>'0'),out_ex_mem_a,out_ex_mem_op,out_ex_mem_b,open, CK );
	PMEM2RE : pipeline port map(out_ex_mem_a,out_ex_mem_op,out_ex_mem_b,(others=>'0'),out_mem_re_a,out_mem_re_op,out_mem_re_b,open, CK );
	
	
end Behavioral;

