----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:53:08 04/30/2020 
-- Design Name: 
-- Module Name:    pipeline1 - Behavioral 
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

entity pipeline1 is
    Port ( Instr : in  STD_LOGIC_VECTOR (31 downto 0);
           CLK : in  STD_LOGIC;
			  Alea : in STD_LOGIC;
           A : out  STD_LOGIC_VECTOR (7 downto 0);
           OP : out  STD_LOGIC_VECTOR (7 downto 0);
           B : out  STD_LOGIC_VECTOR (7 downto 0);
           C : out  STD_LOGIC_VECTOR (7 downto 0));
end pipeline1;

architecture Behavioral of pipeline1 is

begin

	process (CLK)
	begin
		if rising_edge(CLK) then
			--if (Alea = '0') then
				OP <= Instr(31 downto 24);
				A <= Instr(23 downto 16);
				B <= Instr(15 downto 8);
				if (Instr(31 downto 24) = x"01" or Instr(31 downto 24) = x"02" or Instr(31 downto 24) = x"03") then --add, mul, sou
					C <= Instr(7 downto 0);
				else --sinon pas besoin de la derniere operande
					C <= x"00";
				end if;
			--end if;
		end if;
	end process;

end Behavioral;

