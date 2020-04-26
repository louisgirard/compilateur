--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:48:59 04/26/2020
-- Design Name:   
-- Module Name:   D:/Documents/INSA/4A/compilateur/processeur/test_memoireDonnees.vhd
-- Project Name:  processeur
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: memoireDonnees
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
 
ENTITY test_memoireDonnees IS
END test_memoireDonnees;
 
ARCHITECTURE behavior OF test_memoireDonnees IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT memoireDonnees
    PORT(
         Addr : IN  std_logic_vector(7 downto 0);
         E : IN  std_logic_vector(7 downto 0);
         RW : IN  std_logic;
         RST : IN  std_logic;
         CLK : IN  std_logic;
         S : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Addr : std_logic_vector(7 downto 0) := (others => '0');
   signal E : std_logic_vector(7 downto 0) := (others => '0');
   signal RW : std_logic := '0';
   signal RST : std_logic := '0';
   signal CLK : std_logic := '0';

 	--Outputs
   signal S : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: memoireDonnees PORT MAP (
          Addr => Addr,
          E => E,
          RW => RW,
          RST => RST,
          CLK => CLK,
          S => S
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

      wait for CLK_period*10;

      --ecriture a l'adresse 255
		RST <= '1';
		RW <= '0';
		Addr <= x"ff";
		E <= x"02";

      wait for CLK_period*10;		
		--lecture a l'addresse 255
		RW <= '1';		
		Addr <= x"ff";
		
      wait;
   end process;

END;
