----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/17/2024 10:46:39 AM
-- Design Name: 
-- Module Name: MEM - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MEM is
  Port (
    clk: in std_logic;
    MemWrite: in std_logic;
    ALUResIn, rd2: in std_logic_vector(31 downto 0);
    
    MemData, ALUResOut: out std_logic_vector(31 downto 0)
  );
end MEM;

architecture Behavioral of MEM is

type RAMMemory is array(0 to 63) of std_logic_vector(31 downto 0);
signal memRAM: RAMMemory := (
    others => x"00000000"
);

component RAM is
    Port ( clk : in STD_LOGIC;
           we : in STD_LOGIC;
           addr : in STD_LOGIC_VECTOR (5 downto 0);
           di : in STD_LOGIC_VECTOR (31 downto 0);
           do : out STD_LOGIC_VECTOR (31 downto 0));
end component;

signal addr : STD_LOGIC_VECTOR (5 downto 0) := (others => '0');
 
begin

addr <= "00" & ALUResIn(5 downto 2);
connectRAM: RAM port map(clk, MemWrite, addr, rd2, MemData);
ALUResOut <= ALUResIn;

end Behavioral;
