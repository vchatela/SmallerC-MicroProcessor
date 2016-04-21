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
	addr_size_BR: integer:=4;
	width:	integer:=8;
	depth_MD: 	integer:=64;
	size_inst_MI: 	integer:=32;
	size_op: integer:=8 -- size_inst_MI/4
);
	port(	
	  CK : in  STD_LOGIC;
	  RST : in  STD_LOGIC
);
	constant OP_NOP : std_logic_vector(width-1 downto 0)  := x"00";	
	constant OP_ADD : std_logic_vector(width-1 downto 0)  := x"01";
	constant OP_SUB : std_logic_vector(width-1 downto 0) := x"02";
	constant OP_MUL : std_logic_vector(width-1 downto 0) := x"03";
	constant OP_DIV : std_logic_vector(width-1 downto 0) := x"04";
	constant OP_COP : std_logic_vector(width-1 downto 0) := x"05";
	constant OP_AFC : std_logic_vector(width-1 downto 0) := x"06";
	constant OP_LOAD : std_logic_vector(width-1 downto 0) :=x"07";
	constant OP_STORE: std_logic_vector(width-1 downto 0) := x"08";
	constant OP_JMP : std_logic_vector(width-1 downto 0) := x"09";
	constant OP_JMF : std_logic_vector(width-1 downto 0) := x"0A";
	
	
end chemin_donnees;

architecture Behavioral of chemin_donnees is

	component ALU is 
	generic( 
		width:	integer:=8
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
		generic(	width:	integer:=8;
					depth: 	integer:=64);
			
		 Port ( ADDR : in  STD_LOGIC_VECTOR (width-1 downto 0);
				  Din : in  STD_LOGIC_VECTOR (width -1 downto 0);
				  RW : in  STD_LOGIC;
				  RST : in  STD_LOGIC;
				  CK : in  STD_LOGIC;
				  Dout : out  STD_LOGIC_VECTOR (width-1 downto 0));
	end component;

	component Mem_inst is
		generic(	width:	integer:=8;
					size_inst: 	integer:=32);
		 Port ( ADDR : in  STD_LOGIC_VECTOR(width-1 downto 0);
				  CK : in  STD_LOGIC;
				  Dout : out  STD_LOGIC_VECTOR(size_inst-1 downto 0));
	end component;

	component compteur is
		generic(	width:	integer:=8);
		
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
    Port ( in_op : in  STD_LOGIC_VECTOR (size_op-1 downto 0);
			  in_a : in  STD_LOGIC_VECTOR (size_op-1 downto 0);
           in_b : in  STD_LOGIC_VECTOR (size_op-1 downto 0);
           in_c : in  STD_LOGIC_VECTOR (size_op-1 downto 0);
			  out_op : out  STD_LOGIC_VECTOR (size_op-1 downto 0);
           out_a : out  STD_LOGIC_VECTOR (size_op-1 downto 0);
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
	signal in_di_ex_c : STD_LOGIC_VECTOR (size_op-1 downto 0);
	signal out_di_ex_a : STD_LOGIC_VECTOR (size_op-1 downto 0);
	signal out_di_ex_op : STD_LOGIC_VECTOR (size_op-1 downto 0);
	signal out_di_ex_b : STD_LOGIC_VECTOR (size_op-1 downto 0);
	signal out_di_ex_c : STD_LOGIC_VECTOR (size_op-1 downto 0);
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
  signal out_alu :  STD_LOGIC_VECTOR (width-1 downto 0);
  signal out_N :  STD_LOGIC;
  signal out_O :  STD_LOGIC;
  signal out_Z :  STD_LOGIC;
  signal out_C :  STD_LOGIC;
  
  -- Banc Registre --
  signal out_QA :  STD_LOGIC_VECTOR (width-1 downto 0);
  signal out_QB :  STD_LOGIC_VECTOR (width-1 downto 0);
  
  -- Memoire Donnee --
  signal out_DoutD :  STD_LOGIC_VECTOR (width-1 downto 0);
  signal in_addr_md : STD_LOGIC_VECTOR (width-1 downto 0);
  
  -- Memoire Instruction --
  signal out_MI :  STD_LOGIC_VECTOR(size_inst_MI-1 downto 0);
	  
  -- Compteur --
  signal out_CP :  STD_LOGIC_VECTOR (width-1 downto 0);
  signal in_cpt_load : STD_LOGIC;
  signal in_cpt_in : STD_LOGIC_VECTOR (width-1 downto 0);
  -- Unite de detection des aleas
  signal alea : STD_LOGIC;
  
  signal w :  STD_LOGIC;
  signal rw : STD_LOGIC;
  
begin	

	-- Instantiations --
	AL : ALU port map (out_di_ex_b, out_di_ex_c ,out_di_ex_op(2 downto 0), out_alu, out_N, out_O, out_Z, out_C);
		
	-- DATA <= out_mem_re_b; W <= 1; -- AFC on écrit (W <= 1)  - ADD_W <= out_mem_re_a;
	BR : Banc_registres port map (out_li_di_b(addr_size_BR-1 downto 0), out_li_di_c(addr_size_BR-1 downto 0) , 
	out_mem_re_a(addr_size_BR-1 downto 0), w,out_mem_re_b, RST, CK, out_QA,out_QB); 

	-- TODO : check if can save only one
	w <= '0' when out_mem_re_op = OP_STORE else '1';
	-- R : 1(LOAD) - W : 0 (STORE) 
	rw <= '0' when out_mem_re_op = OP_STORE else '1';
	
	MD : Mem_donnee port map ( in_addr_md, out_ex_mem_b , rw, RST, CK, out_DoutD);
	
	MI : Mem_inst port map (out_CP, CK, out_MI);
	CP : compteur port map (CK , RST , '1' , in_cpt_load ,alea , in_cpt_in, out_CP);
	
	-- Multiplexors--	
	-- MUX JM --
		-- MUX JMP si x"09" JMZ si x"0A"
		with out_li_di_op & out_Z select in_cpt_load <=
			'1' when OP_JMP &'1' | OP_JMP&'0' ,
			'1' when OP_JMF &'1',
			'0' when others;
		in_cpt_in <= out_li_di_a when out_li_di_op = OP_JMP else (others=>'0'); -- TODO : JMP 0x1 (JMP @R1) - JMZ 0x1 (JMZ @R1)
	
	-- MUX_BR -- defini si on veut B ou val @B
	in_di_ex_b <= out_QA when out_li_di_op = OP_COP or (out_li_di_op >= OP_ADD and out_li_di_op <= OP_DIV) else out_li_di_b;
	-- MUX_UAL --   ADD x01 SUB x02 .. DIV x04
	in_ex_mem_b <= out_alu when out_di_ex_op >= OP_ADD and out_di_ex_op <= OP_DIV  else out_di_ex_b;
	-- MUX_MD -- A si OP = STORE B si OP = LOAD
	in_addr_md <= out_ex_mem_a when out_ex_mem_op = OP_STORE else out_ex_mem_b;
	in_mem_re_b <= out_DoutD when out_ex_mem_op = OP_LOAD or out_ex_mem_op = OP_STORE else out_ex_mem_b;
	
	-- Unité de détection des aléas   -- TODO : ADD
	alea <= '1' when out_di_ex_op = OP_AFC and out_li_di_op = OP_COP and out_di_ex_a = out_li_di_b else '0';
	
	-- Pipelines --
	in_li_di_c <= out_MI(size_op-1 downto 0);
	in_li_di_b <= out_MI(2*size_op-1 downto size_op);
	in_li_di_a <= out_MI(3*size_op-1 downto 2*size_op);
	in_li_di_op <= out_MI(4*size_op-1 downto 3*size_op) when not(out_di_ex_op = OP_AFC and out_li_di_op = OP_COP and out_di_ex_a = out_li_di_b) else OP_NOP;
	
	PLI2DI : pipeline port map(in_li_di_op,in_li_di_a,in_li_di_b,in_li_di_c,  out_li_di_op,out_li_di_a, out_li_di_b, out_li_di_c, CK );
	PDI2EX : pipeline port map(out_li_di_op, out_li_di_a,  in_di_ex_b, out_QB ,out_di_ex_op,out_di_ex_a,out_di_ex_b,out_di_ex_c, CK );
	PEX2MEM : pipeline port map(out_di_ex_op,out_di_ex_a,in_ex_mem_b,(others=>'0'),out_ex_mem_op,out_ex_mem_a,out_ex_mem_b,open, CK );
	PMEM2RE : pipeline port map(out_ex_mem_op,out_ex_mem_a,in_mem_re_b,(others=>'0'),out_mem_re_op,out_mem_re_a,out_mem_re_b,open, CK );
	
	
end Behavioral;

