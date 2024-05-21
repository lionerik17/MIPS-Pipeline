----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/13/2024 11:42:29 AM
-- Design Name: 
-- Module Name: RegisterFile - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RegisterFile is
  Port (
    clk: in STD_LOGIC;
    rw: in std_logic;
    ra1, ra2: in std_logic_vector(4 downto 0);
    wa: in std_logic_vector(4 downto 0);
    wd: in std_logic_vector(31 downto 0);
    
    rd1, rd2: out std_logic_vector(31 downto 0)
  );
end RegisterFile;

architecture Behavioral of RegisterFile is

type memoryRF is array(0 to 31) of std_logic_vector(31 downto 0);
signal memRF: memoryRF := (
    x"00000000",
    x"00000001",
    x"00000002",
    x"00000003",
    x"00000004",
    x"00000005",
    x"00000006",
    x"00000007",
    x"00000008",
    x"00000009",
    others => x"00000000"
);

begin

writeInRF: process(clk)
begin
    if(falling_edge(clk)) then
        if(rw = '1') then
            memRF(conv_integer(wa)) <= wd;
        end if;
    end if;
end process;

rd1 <= memRF(conv_integer(ra1));
rd2 <= memRF(conv_integer(ra2));

end Behavioral;
