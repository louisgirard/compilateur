----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:55:31 04/30/2020 
-- Design Name: 
-- Module Name:    cheminDonnees - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cheminDonnees is
    Port ( CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC);
end cheminDonnees;

architecture Behavioral of cheminDonnees is
	component memoireInstructions is
		 Port ( Addr : in  STD_LOGIC_VECTOR (7 downto 0);
				  CLK : in  STD_LOGIC;
				  S : out  STD_LOGIC_VECTOR (31 downto 0));
	end component;

	component bancregistres is
		 Port ( A : in  STD_LOGIC_VECTOR (3 downto 0);
				  B : in  STD_LOGIC_VECTOR (3 downto 0);
				  WAddr : in  STD_LOGIC_VECTOR (3 downto 0);
				  W : in  STD_LOGIC; --actif a 1
				  DATA : in  STD_LOGIC_VECTOR (7 downto 0);
				  RST : in  STD_LOGIC; --actif a 0
				  CLK : in  STD_LOGIC;
				  QA : out  STD_LOGIC_VECTOR (7 downto 0);
				  QB : out  STD_LOGIC_VECTOR (7 downto 0));
	end component;
	
	component ual is
    Port ( A : in  STD_LOGIC_VECTOR (7 downto 0);
           B : in  STD_LOGIC_VECTOR (7 downto 0);
           Ctrl_Alu : in  STD_LOGIC_VECTOR (2 downto 0);
           S : out  STD_LOGIC_VECTOR (7 downto 0);
           N : out  STD_LOGIC;
           O : out  STD_LOGIC;
           Z : out  STD_LOGIC;
           C : out  STD_LOGIC);
	end component;
	
	component memoireDonnees is
    Port ( Addr : in  STD_LOGIC_VECTOR (7 downto 0);
           E : in  STD_LOGIC_VECTOR (7 downto 0);
           RW : in  STD_LOGIC; --1=lecture, 0=ecriture
           RST : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
           S : out  STD_LOGIC_VECTOR (7 downto 0));
	end component;
	
	component pipeline1 is
    Port ( Instr : in  STD_LOGIC_VECTOR (31 downto 0);
           A : out  STD_LOGIC_VECTOR (7 downto 0);
           OP : out  STD_LOGIC_VECTOR (7 downto 0);
           B : out  STD_LOGIC_VECTOR (7 downto 0);
           C : out  STD_LOGIC_VECTOR (7 downto 0));
	end component;
	
	component pipeline2 is
    Port ( Ain : in  STD_LOGIC_VECTOR (7 downto 0);
           OPin : in  STD_LOGIC_VECTOR (7 downto 0);
           Bin : in  STD_LOGIC_VECTOR (7 downto 0);
           Cin : in  STD_LOGIC_VECTOR (7 downto 0);
           Aout : out  STD_LOGIC_VECTOR (7 downto 0);
           OPout : out  STD_LOGIC_VECTOR (7 downto 0);
           Bout : out  STD_LOGIC_VECTOR (7 downto 0);
           Cout : out  STD_LOGIC_VECTOR (7 downto 0));
	end component;
	
	component pipeline3 is
    Port ( Ain : in  STD_LOGIC_VECTOR (7 downto 0);
           OPin : in  STD_LOGIC_VECTOR (7 downto 0);
           Bin : in  STD_LOGIC_VECTOR (7 downto 0);
           Aout : out  STD_LOGIC_VECTOR (7 downto 0);
           OPout : out  STD_LOGIC_VECTOR (7 downto 0);
           Bout : out  STD_LOGIC_VECTOR (7 downto 0));
	end component;
	
	component pipeline4 is
    Port ( Ain : in  STD_LOGIC_VECTOR (7 downto 0);
           OPin : in  STD_LOGIC_VECTOR (7 downto 0);
           Bin : in  STD_LOGIC_VECTOR (7 downto 0);
           Aout : out  STD_LOGIC_VECTOR (7 downto 0);
           OPout : out  STD_LOGIC_VECTOR (7 downto 0);
           Bout : out  STD_LOGIC_VECTOR (7 downto 0));
	end component;	
	
	-- signaux intermediaires pour pouvoir mapper les differents composants

	--memoire instructions
	signal memOut : STD_LOGIC_VECTOR (31 downto 0);
	
	--banc de registres
	signal regQA : STD_LOGIC_VECTOR (7 downto 0);
	signal regQB : STD_LOGIC_VECTOR (7 downto 0);
	
	--pipeline1
	signal p1A : STD_LOGIC_VECTOR (7 downto 0);
	signal p1OP : STD_LOGIC_VECTOR (7 downto 0);
	signal p1B : STD_LOGIC_VECTOR (7 downto 0);
	signal p1C : STD_LOGIC_VECTOR (7 downto 0);
	
	--pipeline2
	signal p2A : STD_LOGIC_VECTOR (7 downto 0);
	signal p2OP : STD_LOGIC_VECTOR (7 downto 0);
	signal p2B : STD_LOGIC_VECTOR (7 downto 0);
	signal p2C : STD_LOGIC_VECTOR (7 downto 0);
	
	--pipeline3
	signal p3A : STD_LOGIC_VECTOR (7 downto 0);
	signal p3OP : STD_LOGIC_VECTOR (7 downto 0);
	signal p3B : STD_LOGIC_VECTOR (7 downto 0);
	
	--pipeline4
	signal p4A : STD_LOGIC_VECTOR (7 downto 0);
	signal p4OP : STD_LOGIC_VECTOR (7 downto 0);
	signal p4B : STD_LOGIC_VECTOR (7 downto 0);
	
	--lc
	signal lc3 : STD_LOGIC;

begin
	--mappage des ports des composants
	memInstructions: memoireInstructions port map (
		Addr => x"00", --test avec l'instruction 0
		CLK => CLK,
		S => memOut);
		
	pipelineLIDI: pipeline1 port map (
		Instr => memOut,
		A => p1A,
		OP => p1OP,
		B => p1B,
		C => p1C);
		
	bancReg: bancregistres port map(
		A => p1A(3 downto 0),
		B => p1B(3 downto 0),
		WAddr => p4A(3 downto 0),
		W => lc3, --actif a 1
		DATA => p4B,
		RST => RST, --actif a 0
		CLK => CLK,
		QA => regQA,
		QB => regQB);
		
	pipelineDIEX: pipeline2 port map (
		Ain => p1A,
		OPin => p1OP,
		Bin => p1B,
		Cin => p1C,
		Aout => p2A,
		OPout => p2OP,
		Bout => p2B,
		Cout => p2C);
		
	pipelineEXMem: pipeline3 port map (
		Ain => p2A,
		OPin => p2OP,
		Bin => p2B,
		Aout => p3A,
		OPout => p3OP,
		Bout => p3B);
		
	pipelineMemRE: pipeline4 port map (
		Ain => p3A,
		OPin => p3OP,
		Bin => p3B,
		Aout => p4A,
		OPout => p4OP,
		Bout => p4B);
		
	--lc
	--en fonction de l'instruction on ecrit (1) ou non (0) dans le banc de registres 
	lc3 <= '1' when (p4OP = x"06"); --AFC

end Behavioral;

