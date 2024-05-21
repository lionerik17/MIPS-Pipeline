----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/13/2024 11:07:13 AM
-- Design Name: 
-- Module Name: ROM - Behavioral
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


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ROM is
  Port ( 
    dataIN: in std_logic_vector(5 downto 0);
    dataOUT: out std_logic_vector(31 downto 0)
  );
end ROM;

architecture Behavioral of ROM is

type memoryROM is array(0 to 63) of std_logic_vector(31 downto 0);
signal memROM: memoryROM := (
--
B"000000_00000_00000_00000_00000_100110",
B"000000_00000_00000_00000_00000_000000",
B"000000_00000_00000_00000_00000_000000",
B"001000_00000_00001_0000000000000001",
B"001000_00000_00100_0000000000000000",
B"000000_00111_00111_00111_00000_100110",
B"000000_00000_00000_00000_00000_000000",
B"100011_00100_00011_0000000000000000",
B"001000_00100_00100_0000000000000100",
B"000000_00000_00000_00000_00000_000000",
B"000000_00011_00000_00101_00000_100000",
--
B"000000_00000_00000_00000_00000_000000",
B"000000_00000_00000_00000_00000_000000",
B"000000_00101_00001_00110_00000_100100",
B"000000_00000_00000_00000_00000_000000",
B"000000_00000_00000_00000_00000_000000",
B"000000_00111_00110_00111_00000_100000",
B"101011_00100_00110_0000000000000000",
B"001000_00100_00100_0000000000000100",
B"000000_00000_00101_00101_00001_000010",
B"000000_00000_00000_00000_00000_000000",
B"000000_00000_00000_00000_00000_000000",
B"000111_00101_00000_1111111111111010",
--
B"000000_01001_01001_01001_00000_100110",
B"000000_00000_00000_00000_00000_000000",
B"000000_00000_00000_00000_00000_000000",
B"001000_00000_01001_0000000000000011",
--
B"101011_00100_00111_0000000000000000",
B"000000_00000_00000_00000_00000_000000",
B"000000_00000_00000_00000_00000_000000",
B"000000_00111_01001_01000_00000_101010",
--
others => x"FFFFFFFF"
);

begin

dataOUT <= memROM(conv_integer(dataIN));

end Behavioral;
