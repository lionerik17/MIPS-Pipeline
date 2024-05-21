----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/10/2024 10:20:38 AM
-- Design Name: 
-- Module Name: UC - Behavioral
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

entity UC is
  Port (
    instr: in std_logic_vector(5 downto 0);
    RegDest: out std_logic;
    ExtOp: out std_logic;
    ALUSrc: out std_logic;
    be, bne, bgtz: out std_logic;
    Jump: out std_logic;
    ALUOp: out std_logic_vector(5 downto 0);
    MemWrite: out std_logic;
    MemtoReg: out std_logic;
    RegWrite: out std_logic
  );
end UC;

architecture Behavioral of UC is

begin

decodeInstr:process(instr)
begin
    case instr is
        --tip R
        when "000000" => RegDest <= '1';
                         ExtOp <= '0';
                         AluSrc <= '0';
                         be <= '0';
                         bne <= '0';
                         bgtz <= '0';
                         ALUOp <= "000000";
                         Jump <= '0';
                         MemWrite <= '0';
                         MemtoReg <= '0';
                         RegWrite <= '1';
        
        --addi
        when "001000" => RegDest <= '0';
                         ExtOp <= '1';
                         AluSrc <= '1';
                         be <= '0';
                         bne <= '0';
                         bgtz <= '0';
                         AluOp <= "100000";
                         Jump <= '0';
                         MemWrite <= '0';
                         MemtoReg <= '0';
                         RegWrite <= '1';
        
        --lw
        when "100011" => RegDest <= '0';
                         ExtOp <= '1';
                         ALUSrc <= '1';
                         be <= '0';
                         bne <= '0';
                         bgtz <= '0';
                         Jump <= '0';
                         ALUOp <= "100000";
                         MemWrite <= '0';
                         MemtoReg <= '1';
                         RegWrite <= '1';
        
        --sw
        when "101011" => RegDest <= '0';
                         ExtOp <= '1';
                         ALUSrc <= '1';
                         be <= '0';
                         bne <= '0';
                         bgtz <= '0';
                         Jump <= '0';
                         ALUOp <= "100000";
                         MemWrite <= '1';
                         MemtoReg <= '0';
                         RegWrite <= '0';
        
        --beq
        when "000100" => RegDest <= '0';
                         ExtOp <= '1';
                         ALUSrc <= '0';
                         be <= '1';
                         bne <= '0';
                         bgtz <= '0';
                         Jump <= '0';
                         ALUOp <= "100010";
                         MemWrite <= '0';
                         MemtoReg <= '0';
                         RegWrite <= '0';
        
        --bne
        when "000101" => RegDest <= '0';
                         ExtOp <= '1';
                         ALUSrc <= '0';
                         be <= '0';
                         bne <= '1';
                         bgtz <= '0';
                         Jump <= '0';
                         ALUOp <= "100010";
                         MemWrite <= '0';
                         MemtoReg <= '0';
                         RegWrite <= '0';
        
        --bgtz
        when "000111" => RegDest <= '0';
                         ExtOp <= '1';
                         ALUSrc <= '0';
                         be <= '0';
                         bne <= '0';
                         bgtz <= '1';
                         Jump <= '0';
                         ALUOp <= "100010";
                         MemWrite <= '0';
                         MemtoReg <= '0';
                         RegWrite <= '0';
        
        --j
        when "000010" => RegDest <= '0';
                         ExtOp <= '0';
                         ALUSrc <= '0';
                         be <= '0';
                         bne <= '0';
                         bgtz <= '0';
                         Jump <= '1';
                         ALUOp <= "000000";
                         MemWrite <= '0';
                         MemtoReg <= '0';
                         RegWrite <= '0';                  
                         
         when others =>  RegDest <= '0';
                         ExtOp <= '0';
                         ALUSrc <= '0';
                         be <= '0';
                         bne <= '0';
                         bgtz <= '0';
                         Jump <= '0';
                         ALUOp <= "000000";
                         MemWrite <= '0';
                         MemtoReg <= '0';
                         RegWrite <= '0';                                                                                                                                                                                                                                                                                                                                                          
    end case;
end process;

end Behavioral;
