----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/14/2024 10:11:13 AM
-- Design Name: 
-- Module Name: RAM - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RAM is
    Port ( clk : in STD_LOGIC;
           we : in STD_LOGIC;
           addr : in STD_LOGIC_VECTOR (5 downto 0);
           di : in STD_LOGIC_VECTOR (31 downto 0);
           do : out STD_LOGIC_VECTOR (31 downto 0));
end RAM;

architecture Behavioral of RAM is

type MemoryRAM is array (0 to 63) of std_logic_vector(31 downto 0); 
signal memRAM : MemoryRAM := ( 
x"00000007", --3
others => x"00000000"); 
 
begin 

do <= memRAM(conv_integer(addr));

RAM:process(clk) 
    begin 
        if rising_edge(clk) then 
            if we = '1' then 
                memRAM(conv_integer(addr)) <= di; 
            end if;  
        end if; 
    end process;  
end Behavioral;