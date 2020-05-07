--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:59:47 05/05/2020
-- Design Name:   
-- Module Name:   D:/Documents/INSA/4A/compilateur/processeur/test_cheminDonnees.vhd
-- Project Name:  processeur
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: cheminDonnees
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test_cheminDonnees IS
END test_cheminDonnees;
 
ARCHITECTURE behavior OF test_cheminDonnees IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT cheminDonnees
    PORT(
         CLK : IN  std_logic;
         RST : IN  std_logic;
         AddrInstr : IN  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal RST : std_logic := '0';
   signal AddrInstr : std_logic_vector(7 downto 0) := (others => '0');

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
	constant wait_time : time := CLK_period*2;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: cheminDonnees PORT MAP (
          CLK => CLK,
          RST => RST,
          AddrInstr => AddrInstr
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for CLK_period*10;
		
		RST <= '1';
		AddrInstr <= x"00";

      wait for wait_time;
		
		AddrInstr <= x"01";

      wait for wait_time;
		
		AddrInstr <= x"02";

      wait for wait_time;
		
		AddrInstr <= x"03";

      wait for wait_time*2;
		
		AddrInstr <= x"04";

      wait for wait_time;
		
		AddrInstr <= x"05";

      wait for wait_time;
		
		AddrInstr <= x"06";
		
      wait;
   end process;

END;
