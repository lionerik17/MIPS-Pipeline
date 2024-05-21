----------------------------------------------------------------------------------
-- Problema: Se da un numar pe 32 biti. Sa se determine cati biti de '1' are acel numar. (functional)
--           Sa se verifice daca numarul de biti de 1 este mai mic decat numarul asteptat (functional, dar hard-codat)           
-- Rezolvare: (pentru varianta in binar, a se vedea entitatea ROM)

--00 0x00000026 xor $0, $0, $0 -- init $0 cu 0
--01 0x00000000 noop
--02 0x00000000 noop
--03 0x20010001 addi $1, $0, 1 -- init $1 cu 1
--04 0x20040000 addi $4, $0, 0 -- avem valoarea 0 in registrul $4 (ESI)
--05 0x00E73826 xor $7, $7, $7 -- avem valoarea 0 in registrul $7 (EAX)
--06 0x00000000 noop
--07 0x8C830000 lw $3, offset($4) -- avem numarul (in registrul $3) din memorie, citit de la adresa 0
--08 0x20840004 addi $4, $4, 4 -- $4 = $4 + 4
--09 0x00000000 noop
--10 0x00602820 add $5, $3, $0 -- copie de la numar in registrul $5

--11 0x00000000 noop
--12 0x00000000 noop
--13 0x00A13024 and $6, $5, $1 -- cel mai nesemnicativ bit in registrul $6
--14 0x00000000 noop
--15 0x00000000 noop
--16 0x00E63820 add $7, $7, $6 -- inc reg $7 (EAX)
--17 0xAC860000 sw $6, offset($4) -- scriem de la adresa 4 in colo bitul citit
--18 0x20840004 addi $4, $4, 4 -- $4 = $4 + 4
--19 0x00052882 srl $5, $5, 1 -- impartim copia cu 2
--20 0x00000000 noop
--21 0x00000000 noop
--22 0x1CA0FFFA bgtz $5, -6 -- $5 > 0 ? branch on linia 07 : break

--23 0x01294826 xor $9, $9, $9 -- init $9 cu 0
--24 0x00000000 noop
--25 0x00000000 noop
--26 0x20890000 addi $9, $0, 3 -- numarul corect de biti

--27 0xAC870000 sw $7, offset($4) -- scriem rezultatul in registrul $7 (EAX)
--28 0x00000000 noop
--29 0x00000000 noop
--30 0x0089402A slt $8, $7, $9 -- $8 = $7 < $9 ? 1 : 0 (indicam daca avem eroare)

----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity IFetch is
Port ( 
    clk: in STD_LOGIC;
    reset: in std_logic;
    pcSRC, jump: in std_logic;
    jumpAddress, branchAddress: in std_logic_vector(31 downto 0);
    
    pcPlus4: out std_logic_vector(31 downto 0);
    instruction: out std_logic_vector(31 downto 0)
    );
end IFetch;

architecture Behavioral of IFetch is

signal PC, sum, muxBranch, muxJump: std_logic_vector(31 downto 0) := (others => '0');

component ROM is
  Port ( 
    dataIN: in std_logic_vector(5 downto 0);
    dataOUT: out std_logic_vector(31 downto 0)
  );
end component;

begin

programCounter: process(clk, reset)
begin
    if(reset = '1') then
        PC <= (others => '0');
    elsif(rising_edge(clk)) then
        PC <= muxJump;
    end if;
end process;

connectROM: ROM port map(PC(5 downto 0), instruction);

sum <= PC + 1;
pcPlus4 <= sum;

muxBranch <= sum when pcSrc = '0' else branchAddress;
muxJump <= jumpAddress when jump = '1' else muxBranch;

end Behavioral;
