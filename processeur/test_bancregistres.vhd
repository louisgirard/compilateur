--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:56:45 04/26/2020
-- Design Name:   
-- Module Name:   D:/Documents/INSA/4A/compilateur/processeur/test_bancregistres.vhd
-- Project Name:  processeur
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: bancregistres
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
 
ENTITY test_bancregistres IS
END test_bancregistres;
 
ARCHITECTURE behavior OF test_bancregistres IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT bancregistres
    PORT(
         A : IN  std_logic_vector(3 downto 0);
         B : IN  std_logic_vector(3 downto 0);
         WAddr : IN  std_logic_vector(3 downto 0);
         W : IN  std_logic;
         DATA : IN  std_logic_vector(7 downto 0);
         RST : IN  std_logic;
         CLK : IN  std_logic;
         QA : OUT  std_logic_vector(7 downto 0);
         QB : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal A : std_logic_vector(3 downto 0) := (others => '0');
   signal B : std_logic_vector(3 downto 0) := (others => '0');
   signal WAddr : std_logic_vector(3 downto 0) := (others => '0');
   signal W : std_logic := '0';
   signal DATA : std_logic_vector(7 downto 0) := (others => '0');
   signal RST : std_logic := '0';
   signal CLK : std_logic := '0';

 	--Outputs
   signal QA : std_logic_vector(7 downto 0);
   signal QB : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: bancregistres PORT MAP (
          A => A,
          B => B,
          WAddr => WAddr,
          W => W,
          DATA => DATA,
          RST => RST,
          CLK => CLK,
          QA => QA,
          QB => QB
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

      -- insert stimulus here 
		
		RST <= '1';
		--ecriture dans le registre 15
		W <= '1';
		DATA <= x"02";
		WAddr <= x"F";

      wait for CLK_period*10;
		--ecriture dans le registre 13
		W <= '1';
		DATA <= x"06";
		WAddr <= x"D";

      wait for CLK_period*10;
		
		--lecture des deux registres, 13 et 15
		W <= '0';
		A <= x"F";
		B <= x"D";
		
      wait for CLK_period*10;
		--reset
		RST <= '0';
		
      wait for CLK_period*10;
		--ecriture et lecture en simultanee
		RST <= '1';
		W <= '1';
		DATA <= x"0A";
		WAddr <= x"E";
		A <= x"E";
		
      wait;
   end process;

END;
