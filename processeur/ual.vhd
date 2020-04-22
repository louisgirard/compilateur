----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:11:40 04/22/2020 
-- Design Name: 
-- Module Name:    ual - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ual is
    Port ( CLK : in  STD_LOGIC;
			  A : in  STD_LOGIC_VECTOR (7 downto 0);
           B : in  STD_LOGIC_VECTOR (7 downto 0);
           Ctrl_Alu : in  STD_LOGIC_VECTOR (2 downto 0);
           S : out  STD_LOGIC_VECTOR (7 downto 0);
           N : out  STD_LOGIC;
           O : out  STD_LOGIC;
           Z : out  STD_LOGIC;
           C : out  STD_LOGIC);
end ual;

architecture Behavioral of ual is
	signal S_AUX : STD_LOGIC_VECTOR (15 downto 0);
begin
	
	process
	begin
       wait until CLK'event and CLK='1';
		
		case Ctrl_Alu is
			when "000" => --addition
				S_AUX <= (b"00000000" & A) + (b"00000000" & B);
				S <= S_AUX(7 downto 0);
				C <= S_AUX(8);
				if ((A(7)='0' and B(7)='0' and S_AUX(7)='1') or (A(7)='1' and B(7)='1' and S_AUX(7)='0')) then
					O <= '1';
				else
					O <= '0';
				end if;
			when "001" => --multiplication retenue / 16bits -> 8bits ?
				S_AUX <= A * B;
				S <= S_AUX(7 downto 0);
				C <= '0';
				-- positif * positif, negatif * negatif, positif * negatif, negatif * positif
				if ((A(7)='0' and B(7)='0' and S_AUX(7)='1') or (A(7)='1' and B(7)='1' and S_AUX(7)='1') or
				(A(7)='0' and B(7)='1' and S_AUX(7)='0') or (A(7)='1' and B(7)='0' and S_AUX(7)='0')) then
					O <= '1';
				else
					O <= '0';
				end if;
			when "010" => --soustraction -> retenue ou pas ?
				S_AUX <= (b"00000000" & A) - (b"00000000" & B);
				S <= S_AUX(7 downto 0);
				C <= '0';
				if ((A(7)='0' and B(7)='1' and S_AUX(7)='1') or (A(7)='1' and B(7)='0' and S_AUX(7)='0')) then
					O <= '1';
				else
					O <= '0';
				end if;
			when "011" => --division
				--S <= A / B;
				--S_AUX <= A / B;
				S_AUX <= "1111111111111111";
				S <= S_AUX(7 downto 0);
				C <= '0';
				O <= '0';
			when others =>
			
		end case;
		N <= S_AUX(7);
		if (S_AUX="0") then
			Z <= '0';
		else
			Z <= '1';
		end if;
		
	end process;

end Behavioral;

