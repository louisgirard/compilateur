----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:32:32 04/26/2020 
-- Design Name: 
-- Module Name:    bancregistres - Behavioral 
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

entity bancregistres is
    Port ( A : in  STD_LOGIC_VECTOR (3 downto 0);
           B : in  STD_LOGIC_VECTOR (3 downto 0);
           WAddr : in  STD_LOGIC_VECTOR (3 downto 0);
           W : in  STD_LOGIC; --actif a 1
           DATA : in  STD_LOGIC_VECTOR (7 downto 0);
           RST : in  STD_LOGIC; --actif a 0
           CLK : in  STD_LOGIC;
           QA : out  STD_LOGIC_VECTOR (7 downto 0);
           QB : out  STD_LOGIC_VECTOR (7 downto 0));
end bancregistres;

architecture Behavioral of bancregistres is

type regs is array (integer range 15 downto 0) of STD_LOGIC_VECTOR(7 downto 0);
signal registres : regs;

begin
	process(CLK)
	begin
		if rising_edge(CLK) then
			if RST='0' then
				registres <= (others=>(others=>'0'));
			else
				if W='1' then
					registres(to_integer(unsigned(WAddr))) <= DATA;
					if WAddr=A then
						QA <= DATA;
					elsif WAddr=B then
						QB <= DATA;
					end if;
				else
					QA <= registres(to_integer(unsigned(A)));
					QB <= registres(to_integer(unsigned(B)));
				end if;
			end if;
		end if;
		for I in 0 to 15 loop
			report "Registre " & integer'image(I) & ", valeur : " & integer'image(to_integer(unsigned(registres(I))));
		end loop;
	end process;

end Behavioral;

