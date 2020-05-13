----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:17:39 03/26/2020 
-- Design Name: 
-- Module Name:    compteur - Behavioral 
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
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity compteur is
	Port ( CLK : in  STD_LOGIC;
		EN : in  STD_LOGIC; --actif a 0
		SENS : in  STD_LOGIC; --1 augmente, 0 diminue
		RST : in  STD_LOGIC; --actif a 0
		Alea : in STD_LOGIC;
		Dout : out  STD_LOGIC_VECTOR (7 downto 0));
end compteur;

architecture Behavioral of compteur is

    signal AUX : STD_LOGIC_VECTOR (7 downto 0);

begin
	process(CLK)
	begin
		if rising_edge(CLK) then
			if RST='0' then
				AUX <= x"00";
			else
				if EN='0' then
					if SENS='1' then
						AUX <= AUX + 1;
						if Alea = '1' then
							AUX <= AUX - 1;
						end if;
						Dout <= AUX;
					else
						AUX <= AUX - 1;
					end if;
				end if;    
			end if;
		end if;
	end process;
    
end Behavioral;
