----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/07/2024 09:22:43 PM
-- Design Name: 
-- Module Name: SSD - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SSD is
    port(
        digits: in std_logic_vector(31 downto 0);
        clk: in std_logic;
        
        an: out std_logic_vector(7 downto 0);
        cat: out std_logic_vector(6 downto 0)   
    );
end SSD;

architecture Behavioral of SSD is

signal cnt_in: std_logic_vector(16 downto 0) := (others => '0');
signal sel: std_logic_vector(2 downto 0) := (others => '0');
signal out_mux1: std_logic_vector(3 downto 0) := (others => '0');

begin

process(clk)
begin
    if(rising_edge(clk)) then
        cnt_in <= cnt_in + 1;
    end if;
end process;

sel <= cnt_in(16 downto 14);

process(sel, digits)
begin
    case sel is
        when "000" => out_mux1 <= digits(3 downto 0);
        when "001" => out_mux1 <= digits(7 downto 4);
        when "010" => out_mux1 <= digits(11 downto 8);
        when "011" => out_mux1 <= digits(15 downto 12);
        when "100" => out_mux1 <= digits(19 downto 16);
        when "101" => out_mux1 <= digits(23 downto 20);
        when "110" => out_mux1 <= digits(27 downto 24);
        when "111" => out_mux1 <= digits(31 downto 28);
        when others => out_mux1 <= digits(3 downto 0);
    end case;
end process;

process(sel)
begin
    case sel is
        when "000" => an <= "11111110";
        when "001" => an <= "11111101";
        when "010" => an <= "11111011";
        when "011" => an <= "11110111";
        when "100" => an <= "11101111";
        when "101" => an <= "11011111";
        when "110" => an <= "10111111";
        when "111" => an <= "01111111";
        when others => an <= "11111110";
    end case;
end process;

-- segment encoinputg
--      0
--     ---
--  5 |   | 1
--     ---   <- 6
--  4 |   | 2
--     ---
--      3

with out_mux1 select
     cat <= "1111001" when "0001",   --1
                "0100100" when "0010",   --2
                "0110000" when "0011",   --3
                "0011001" when "0100",   --4
                "0010010" when "0101",   --5
                "0000010" when "0110",   --6
                "1111000" when "0111",   --7
                "0000000" when "1000",   --8
                "0010000" when "1001",   --9
                "0001000" when "1010",   --A
                "0000011" when "1011",   --b
                "1000110" when "1100",   --C
                "0100001" when "1101",   --d
                "0000110" when "1110",   --E
                "0001110" when "1111",   --F
                "1000000" when others;   --0

end Behavioral;
