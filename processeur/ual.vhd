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
    Port ( A : in  STD_LOGIC_VECTOR (7 downto 0);
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
	
	process (A,B,Ctrl_Alu,S_AUX) is
	begin
		case Ctrl_Alu is
			when "000" => --addition
				S_AUX <= (x"00" & A) + (x"00" & B);
			when "001" => --multiplication
				S_AUX <= A * B;
			when "010" => --soustraction
				S_AUX <= (x"00" & A) - (x"00" & B);
			when others =>
				S_AUX <= x"ffff";
			
		end case;
		S <= S_AUX(7 downto 0);
		N <= S_AUX(15);
		if (S_AUX(15 downto 8) /= x"00" and S_AUX(15) = '0') then
			O <= '1';
		else
			O <= '0';
		end if;
		if (S_AUX(7 downto 0) = x"00") then
			Z <= '1';
		else
			Z <= '0';
		end if;
		if (S_AUX(15) = '0' and S_AUX(8)='1') then
			C <= '1';
		else
			C <= '0';
		end if;
		
	end process;

end Behavioral;

