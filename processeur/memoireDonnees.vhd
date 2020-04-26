----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:36:01 04/26/2020 
-- Design Name: 
-- Module Name:    memoireDonnees - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity memoireDonnees is
    Port ( Addr : in  STD_LOGIC_VECTOR (7 downto 0);
           E : in  STD_LOGIC_VECTOR (7 downto 0);
           RW : in  STD_LOGIC; --1=lecture, 0=ecriture
           RST : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
           S : out  STD_LOGIC_VECTOR (7 downto 0));
end memoireDonnees;

architecture Behavioral of memoireDonnees is

type mem is array (integer range 255 downto 0) of STD_LOGIC_VECTOR(7 downto 0);
signal memoire : mem;

begin
	process(CLK)
	begin
		if rising_edge(CLK) then			
			if RST='0' then
				memoire <= (others=>(others=>'0'));
			else
				if RW='0' then --ecriture
					memoire(to_integer(unsigned(Addr))) <= E;
					S <= x"00";
				else --lecture
					S <= memoire(to_integer(unsigned(Addr)));
				end if;				
			end if;
		end if;
	end process;


end Behavioral;

