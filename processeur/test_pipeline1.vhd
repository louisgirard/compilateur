--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:30:28 04/30/2020
-- Design Name:   
-- Module Name:   D:/Documents/INSA/4A/compilateur/processeur/test_pipeline1.vhd
-- Project Name:  processeur
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: pipeline1
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
 
ENTITY test_pipeline1 IS
END test_pipeline1;
 
ARCHITECTURE behavior OF test_pipeline1 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT pipeline1
    PORT(
         Instr : IN  std_logic_vector(31 downto 0);
         A : OUT  std_logic_vector(7 downto 0);
         OP : OUT  std_logic_vector(7 downto 0);
         B : OUT  std_logic_vector(7 downto 0);
         C : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Instr : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal A : std_logic_vector(7 downto 0);
   signal OP : std_logic_vector(7 downto 0);
   signal B : std_logic_vector(7 downto 0);
   signal C : std_logic_vector(7 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: pipeline1 PORT MAP (
          Instr => Instr,
          A => A,
          OP => OP,
          B => B,
          C => C
        );

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      -- insert stimulus here 
		Instr <= x"01000203";

      wait;
   end process;

END;
