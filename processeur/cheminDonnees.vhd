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
           RST : in  STD_LOGIC;
			  AddrInstr : in  STD_LOGIC_VECTOR (7 downto 0));
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
    Port ( CLK : in  STD_LOGIC;
			  Instr : in  STD_LOGIC_VECTOR (31 downto 0);
			  Alea : in STD_LOGIC;
           A : out  STD_LOGIC_VECTOR (7 downto 0);
           OP : out  STD_LOGIC_VECTOR (7 downto 0);
           B : out  STD_LOGIC_VECTOR (7 downto 0);
           C : out  STD_LOGIC_VECTOR (7 downto 0));
	end component;
	
	component pipeline2 is
    Port ( CLK : in  STD_LOGIC;
			  Ain : in  STD_LOGIC_VECTOR (7 downto 0);
           OPin : in  STD_LOGIC_VECTOR (7 downto 0);
           Bin : in  STD_LOGIC_VECTOR (7 downto 0);
           Cin : in  STD_LOGIC_VECTOR (7 downto 0);
           Aout : out  STD_LOGIC_VECTOR (7 downto 0);
           OPout : out  STD_LOGIC_VECTOR (7 downto 0);
           Bout : out  STD_LOGIC_VECTOR (7 downto 0);
           Cout : out  STD_LOGIC_VECTOR (7 downto 0));
	end component;
	
	component pipeline3 is
    Port ( CLK : in  STD_LOGIC;
			  Ain : in  STD_LOGIC_VECTOR (7 downto 0);
           OPin : in  STD_LOGIC_VECTOR (7 downto 0);
           Bin : in  STD_LOGIC_VECTOR (7 downto 0);
           Aout : out  STD_LOGIC_VECTOR (7 downto 0);
           OPout : out  STD_LOGIC_VECTOR (7 downto 0);
           Bout : out  STD_LOGIC_VECTOR (7 downto 0));
	end component;
	
	component pipeline4 is
    Port ( CLK : in  STD_LOGIC;
			  Ain : in  STD_LOGIC_VECTOR (7 downto 0);
           OPin : in  STD_LOGIC_VECTOR (7 downto 0);
           Bin : in  STD_LOGIC_VECTOR (7 downto 0);
           Aout : out  STD_LOGIC_VECTOR (7 downto 0);
           OPout : out  STD_LOGIC_VECTOR (7 downto 0);
           Bout : out  STD_LOGIC_VECTOR (7 downto 0));
	end component;	
	
	-- signaux intermediaires pour pouvoir mapper les differents composants

	--memoire instructions
	signal memInstrOut : STD_LOGIC_VECTOR (31 downto 0);
	
	--banc de registres
	signal regQA : STD_LOGIC_VECTOR (7 downto 0);
	signal regQB : STD_LOGIC_VECTOR (7 downto 0);
	
	--alu
	signal aluS : STD_LOGIC_VECTOR (7 downto 0);
	
	--memoire donnees
	signal memDonneesOut : STD_LOGIC_VECTOR (7 downto 0);
	
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
	
	--multiplexeurs
	signal mux1 : STD_LOGIC_VECTOR (7 downto 0);
	signal mux2 : STD_LOGIC_VECTOR (7 downto 0);
	signal mux3 : STD_LOGIC_VECTOR (7 downto 0);
	signal mux4 : STD_LOGIC_VECTOR (7 downto 0);
	
	--lc
	signal lc1 : STD_LOGIC_VECTOR (2 downto 0);
	signal lc2 : STD_LOGIC;
	signal lc3 : STD_LOGIC;
	
	--aleas
	signal alea : STD_LOGIC;
	signal p1WR : STD_LOGIC; --0 lecture, 1 ecriture
	signal p2WR : STD_LOGIC; --0 lecture, 1 ecriture
	signal p3WR : STD_LOGIC; --0 lecture, 1 ecriture
	
begin
	--mappage des ports des composants
	memInstructions: memoireInstructions port map (
		Addr => AddrInstr, --test avec l'instruction 0
		CLK => CLK,
		S => memInstrOut);
		
	pipelineLIDI: pipeline1 port map (
		CLK => CLK,
		Instr => memInstrOut,
		Alea => alea,
		A => p1A,
		OP => p1OP,
		B => p1B,
		C => p1C);
		
	bancReg: bancregistres port map(
		A => p1B(3 downto 0),
		B => p1C(3 downto 0),
		WAddr => p4A(3 downto 0),
		W => lc3, --actif a 1
		DATA => p4B,
		RST => RST, --actif a 0
		CLK => CLK,
		QA => regQA,
		QB => regQB);
		
	pipelineDIEX: pipeline2 port map (
		CLK => CLK,
		Ain => p1A,
		OPin => p1OP,
		Bin => mux1,
		Cin => regQB,
		Aout => p2A,
		OPout => p2OP,
		Bout => p2B,
		Cout => p2C);
		
	alu: ual port map (
		A => p2B,
		B => p2C,
		Ctrl_alu => lc1,
		S => aluS);		
		
	pipelineEXMem: pipeline3 port map (
		CLK => CLK,
		Ain => p2A,
		OPin => p2OP,
		Bin => mux2,
		Aout => p3A,
		OPout => p3OP,
		Bout => p3B);
		
	memDonnees: memoireDonnees port map(
		Addr => mux3,
		E => p3B,
		RW => lc2,
		RST => RST,
		CLK => CLK,
		S => memDonneesOut);
		
	pipelineMemRE: pipeline4 port map (
		CLK => CLK,
		Ain => p3A,
		OPin => p3OP,
		Bin => mux4,
		Aout => p4A,
		OPout => p4OP,
		Bout => p4B);
		
	--multiplexeurs
	--en fonction de l'instruction on prend la sortie B du pipeline1 ou la sortie QA du banc de registres si
	--on a besoin de lire la valeur dans le registre
	mux1 <= regQA when p1OP = x"01" or p1OP = x"02" or p1OP = x"03" or p1OP = x"05" or p1OP = x"08" else p1B; --ADD, MUL, SOU, COP, STORE
	--besoin de l'alu uniquement pour les operations arithmetiques
	mux2 <= aluS when p2OP = x"01" or p2OP = x"02" or p2OP = x"03" else p2B; --ADD, MUL, SOU
	mux3 <= p3A when p3OP = x"08" else p3B; --STORE
	--lecture de donnees uniquement en LOAD
	mux4 <= memDonneesOut when p3OP = x"07" else p3B; --LOAD
			
	--lc
	lc1 <= "000" when p2OP = x"01" --ADD
	else "001" when p2OP = x"02" --MUL
	else "010" when p2OP = x"03" --SOU
	else "111";
	
	lc2 <= '0' when p3OP = x"08" else '1'; --ecriture quand STORE sinon lecture
	
	--en fonction de l'instruction on ecrit (1) ou non (0) dans le banc de registres 
	lc3 <= '0' when p4OP = x"08" else '1'; --lecture pour STORE, les autres ecrivent

	--aleas
	p1WR <= '1' when p1OP = x"06" or p1OP = x"07" else '0'; --lecture dans le banc de registres pour tout le monde sauf AFC et LOAD
	p2WR <= '0' when p2OP = x"08" else '1'; --lecture pour STORE, ecriture pour tout le monde dans le banc de registres
	p3WR <= '0' when p2OP = x"08" else '1'; --lecture pour STORE, ecriture pour tout le monde
	
	alea <= '1' when 
	((p1WR = '0' and p2WR = '1' and (p2A = p1B or p2A = p1C)) or
	(p1WR = '0' and p3WR = '1' and (p3A = p1B or p3A = p1C)))
	else '0';

end Behavioral;

