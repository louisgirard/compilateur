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

begin
	--mappage des ports des composants
	memInstructions: memoireInstructions port map (
		Addr => x"00",
		CLK => CLK,
		S => pipeline1.Ins);


end Behavioral;

