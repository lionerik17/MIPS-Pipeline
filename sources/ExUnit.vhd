----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/17/2024 08:55:20 AM
-- Design Name: 
-- Module Name: ExUnit - Behavioral
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

entity ExUnit is
  Port ( 
    rd1, rd2, Ext_Imm: in std_logic_vector(31 downto 0);
    AluSrc: in std_logic;
    sa: in std_logic_vector(4 downto 0);
    func, AluOp: in std_logic_vector(5 downto 0);
    pcPlus4: in std_logic_vector(31 downto 0);
    rt, rd: in std_logic_vector(4 downto 0);
    regDest: in std_logic;
    
    be, bgtz, bne: out std_logic;
    branchAddress, ALURes: out std_logic_vector(31 downto 0);
    rWA: out std_logic_vector(4 downto 0)
  );
end ExUnit;

architecture Behavioral of ExUnit is

signal operation: std_logic_vector(5 downto 0) := (others => '0');
signal secondOperand: std_logic_vector(31 downto 0) := (others => '0');

begin

secondOperand <= rd2 when AluSrc = '0' else Ext_Imm;
operation <= func when AluOp = 0 else AluOp;
BranchAddress <= pcPlus4 + Ext_Imm;
rWA <= rt when regDest = '0' else rd;

ALU: process(rd1, secondOperand, operation)
     variable result: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
     begin
        case operation is
            --add
            when "100000" => result := rd1 + secondOperand;
            
            --sub
            when "100010" => result := rd1 - secondOperand;
            
            --and
            when "100100" => result := rd1 and secondOperand;
            
            --or
            when "100101" => result := rd1 or secondOperand;
            
            --xor
            when "100110" => result := rd1 xor secondOperand;
            
            --sll/noop
            when "000000" => result := to_stdlogicvector(to_bitvector(secondOperand) sll conv_integer(sa));
            
            --srl
            when "000010" => result := to_stdlogicvector(to_bitvector(secondOperand) srl conv_integer(sa));
            
            --slt
            when "101010" =>
                if(rd1 < secondOperand) then
                    result := x"00000001";
                else
                    result := (others => '0');   
                end if;
            
            when others => result := x"11111111";
        end case;
            
        if(result = 0) then
           be <= '1';
           bne <= '0';
        else
           be <= '0';
           bne <= '1';
        end if;
                
        if(signed(rd1) > 0) then
           bgtz <= '1';
        else
           bgtz <= '0';
        end if;
         
        ALURes <= result;                   
     end process;
end Behavioral;
