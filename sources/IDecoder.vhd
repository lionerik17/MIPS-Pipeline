----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/03/2024 11:04:44 PM
-- Design Name: 
-- Module Name: IDecoder - Behavioral
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
use IEEE.NUMERIC_STD.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IDecoder is
    port(
        clk: in std_logic;
        regWrite, extOP: in std_logic;
        instruction: in std_logic_vector(25 downto 0);
        writeData: in std_logic_vector(31 downto 0);
        writeAddress: in std_logic_vector(4 downto 0);
        
        readData1, readData2: out std_logic_vector(31 downto 0);
        rt, rd: out std_logic_vector(4 downto 0);
        extIMM: out std_logic_vector(31 downto 0);
        func: out std_logic_vector(5 downto 0);
        sa: out std_logic_vector(4 downto 0)
    );
end IDecoder;

architecture Behavioral of IDecoder is

component RegisterFile is
  Port (
    clk: in STD_LOGIC;
    rw: in std_logic;
    ra1, ra2: in std_logic_vector(4 downto 0);
    wa: in std_logic_vector(4 downto 0);
    wd: in std_logic_vector(31 downto 0);
    
    rd1, rd2: out std_logic_vector(31 downto 0)
  );
end component;

begin

connectRegFile: RegisterFile port map(clk, regWrite, instruction(25 downto 21), instruction(20 downto 16), writeAddress, writeData, readData1, readData2);

extIMM(15 downto 0) <= instruction(15 downto 0);
extIMM(31 downto 16) <= (others => '0') when extOP = '0' else (others => instruction(15));

rt <= instruction(20 downto 16);
rd <= instruction(15 downto 11);

func <= instruction(5 downto 0);
sa <= instruction(10 downto 6);

end Behavioral;
