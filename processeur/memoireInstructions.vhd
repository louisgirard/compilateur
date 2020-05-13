----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:54:19 04/26/2020 
-- Design Name: 
-- Module Name:    memoireInstructions - Behavioral 
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

entity memoireInstructions is
    Port ( Addr : in  STD_LOGIC_VECTOR (7 downto 0);
           CLK : in  STD_LOGIC;
           S : out  STD_LOGIC_VECTOR (31 downto 0));
end memoireInstructions;

architecture Behavioral of memoireInstructions is

type mem is array (integer range 255 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
signal memoire : mem;

begin
	memoire(0) <= x"06010f00"; -- affectation dans le registre 1 de la valeur 15 (f) 
	memoire(1) <= x"06020a00"; -- affectation dans le registre 2 de la valeur 10 (a)
	memoire(2) <= x"01040102"; -- addition dans registre 4 de registre 1 + registre 2 (15 + 10 = 25)	
	memoire(3) <= x"05050100"; -- copie dans le registre 5 de la valeur dans le registre 1 (15)
	memoire(4) <= x"020a0402"; -- multiplication dans registre 10 de registre 4 * registre 2 (25 * 10 = 250)
	memoire(5) <= x"08050400"; -- store a l'adresse 5 la valeur du registre 4 (25)
	--memoire(6) <= x"07030500"; -- load dans le registre 3 de la valeur a l'adresse 5 (25)

	process(CLK)
	begin
		if rising_edge(CLK) then
			S <= memoire(to_integer(unsigned(Addr)));
		end if;
	end process;


end Behavioral;

