library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity test_env is
    port(
        clk: in STD_LOGIC;
        btn: in STD_LOGIC_VECTOR(4 downto 0);
        sw: in STD_LOGIC_VECTOR(15 downto 0);
        
        led: out STD_LOGIC_VECTOR(15 downto 0);
        an: out STD_LOGIC_VECTOR(7 downto 0);
        cat: out STD_LOGIC_VECTOR(6 downto 0)
    );
end test_env;

architecture Behavioral of test_env is

component MPG is
    Port ( enable : out STD_LOGIC;
           btn : in STD_LOGIC;
           clk : in STD_LOGIC);
end component;

component SSD is
    port(
        digits: in std_logic_vector(31 downto 0);
        clk: in std_logic;
        
        an: out std_logic_vector(7 downto 0);
        cat: out std_logic_vector(6 downto 0)   
    );
end component;

component IFetch is
Port ( 
    clk: in STD_LOGIC;
    reset: in std_logic;
    pcSRC, jump: in std_logic;
    jumpAddress, branchAddress: in std_logic_vector(31 downto 0);
    
    pcPlus4: out std_logic_vector(31 downto 0);
    instruction: out std_logic_vector(31 downto 0)
    );
end component;

component IDecoder is
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
end component;

component UC is
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
end component;

component ExUnit is
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
end component;

component MEM is
  Port (
    clk: in std_logic;
    MemWrite: in std_logic;
    ALUResIn, rd2: in std_logic_vector(31 downto 0);
    
    MemData, ALUResOut: out std_logic_vector(31 downto 0)
  );
end component;

--de bun simt
signal en, rst: std_logic := '0';
signal output: std_logic_vector(31 downto 0) := (others => '0');

--IFetch
signal PCSrc, Jump: std_logic := '0';
signal JumpAddress, BranchAddress, PCPlus4, instr: std_logic_vector(31 downto 0) := (others => '0');

--IDecoder
signal instr_ID: std_logic_vector(31 downto 0) := (others => '0');
signal Rwrite, Rdest, Ext_Op: std_logic := '0';
signal rd1, rd2, WriteData, Ext_Imm: std_logic_vector(31 downto 0) := (others => '0'); 
signal func: std_logic_vector(5 downto 0) := (others => '0');
signal sa: std_logic_vector(4 downto 0) := (others => '0');
signal writeData_ID : std_logic_vector(31 downto 0) := (others => '0');
signal rt, rd, writeAddress_ID: std_logic_vector(4 downto 0) := (others => '0');

--UC
signal Ext_Op_UC, jump_UC: std_logic := '0';
signal instr_UC: std_logic_vector(31 downto 0) := (others => '0');
signal ALUSrc : std_logic := '0';
signal BranchOnEqual : std_logic := '0';
signal BranchNotEqual : std_logic := '0';
signal BranchGreaterThanZero : std_logic := '0';
signal ALUOp : std_logic_vector(5 downto 0) := "000000";
signal MemWrite : std_logic := '0';
signal MemtoReg : std_logic := '0';
signal rwrite_UC : std_logic := '0';

--ExUnit
signal be : std_logic := '0';
signal bne : std_logic := '0';
signal bgtz : std_logic := '0';
signal ALURes_EX : std_logic_vector(31 downto 0) := (others => '0');
signal rWA: std_logic_vector(4 downto 0) := (others => '0');
signal pcPlus4_EX, branchAddress_EX: std_logic_vector(31 downto 0) := (others => '0');
signal ALUOP_EX: std_logic_vector(5 downto 0) := "000000";
signal rd1_EX, rd2_EX, Ext_Imm_EX: std_logic_vector(31 downto 0) := (others => '0');
signal sa_EX: std_logic_vector(4 downto 0) := (others => '0');
signal func_EX: std_logic_vector(5 downto 0) := (others => '0');
signal rt_EX, rd_EX: std_logic_vector(4 downto 0) := (others => '0');
signal ALUSrc_EX, rdest_EX: std_logic := '0'; 

--MEM
signal MemWrite_MEM: std_logic := '0';
signal MemData_MEM : std_logic_vector(31 downto 0) := (others => '0');
signal ALURESIn_MEM: std_logic_vector(31 downto 0) := (others => '0');
signal ALUResOut_MEM : std_logic_vector(31 downto 0) := (others => '0');
signal rd2_MEM: std_logic_vector(31 downto 0) := (others => '0');

--Pipeline Registers
signal IF_ID: std_logic_vector(63 downto 0);
signal ID_EX: std_logic_vector(162 downto 0);
signal EX_MEM: std_logic_vector(109 downto 0);
signal MEM_WB: std_logic_vector(70 downto 0);

begin  
    connectMPG: MPG port map(en, btn(0), clk);
    rst <= btn(1); 
    pipelineRegisters:process(en)
    begin
        if(rising_edge(en)) then
            IF_ID(31 downto 0) <= pcPlus4;
            IF_ID(63 downto 32) <= instr;
            
            ID_EX(0) <= MemtoReg;
            ID_EX(1) <= rwrite;
            ID_EX(2) <= MemWrite;
            ID_EX(3) <= BranchOnEqual;
            ID_EX(4) <= BranchNotEqual;
            ID_EX(5) <= BranchGreaterThanZero;
            ID_EX(11 downto 6) <= ALUOp;
            ID_EX(12) <= ALUSrc;
            ID_EX(13) <= rdest;
            ID_EX(45 downto 14) <= IF_ID(31 downto 0);
            ID_EX(77 downto 46) <= rd1;
            ID_EX(109 downto 78) <= rd2;
            ID_EX(114 downto 110) <= sa;
            ID_EX(146 downto 115) <= Ext_Imm;
            ID_EX(152 downto 147) <= func;
            ID_EX(157 downto 153) <= rt;
            ID_EX(162 downto 158) <= rd;
            
            EX_MEM(5 downto 0) <= ID_EX(5 downto 0);
            EX_MEM(37 downto 6) <= branchAddress_EX;
            EX_MEM(38) <= be;
            EX_MEM(39) <= bne;
            EX_MEM(40) <= bgtz;
            EX_MEM(72 downto 41) <= ALURes_EX;
            EX_MEM(104 downto 73) <= ID_EX(109 downto 78);
            EX_MEM(109 downto 105) <= rWA;
            
            MEM_WB(1 downto 0) <= EX_MEM(1 downto 0);
            MEM_WB(33 downto 2) <= MemData_MEM;
            MEM_WB(65 downto 34) <= ALURESOut_MEM;
            MEM_WB(70 downto 66) <= EX_MEM(109 downto 105);
        end if;
    end process;
    
    --IF
    jumpAddress <= IF_ID(31 downto 26) & IF_ID(57 downto 32);
    branchAddress <= EX_MEM(37 downto 6);
    jump <= jump_UC;
    PCSrc <= (EX_MEM(3) and EX_MEM(38)) or (EX_MEM(4) and EX_MEM(39)) or (EX_MEM(5) and EX_MEM(40));
    
    --IDecoder
    instr_ID <= IF_ID(63 downto 32);
    rwrite <= ID_EX(1);
    Ext_Op <= Ext_Op_UC;
    writeAddress_ID <= MEM_WB(70 downto 66);
    writeData_ID <= writeData;
    
    --UC
    instr_UC <= IF_ID(63 downto 32);
    
    --ExUnit
    rd1_EX <= ID_EX(77 downto 46);
    rd2_EX <= ID_EX(109 downto 78);
    ALUOP_EX <= ID_EX(11 downto 6);
    ALUSrc_EX <= ID_EX(12);
    rdest_EX <= ID_EX(13);
    rt_EX <= ID_EX(157 downto 153);
    rd_EX <= ID_EX(162 downto 158);
    sa_EX <= ID_EX(114 downto 110);
    Ext_Imm_EX <= ID_EX(146 downto 115);
    func_EX <= ID_EX(152 downto 147);
    pcPlus4_EX <= ID_EX(45 downto 14);
    
    --MEM
    MemWrite_MEM <= EX_MEM(2);
    ALUResIN_MEM <= EX_MEM(72 downto 41);
    rd2_MEM <= EX_MEM(104 downto 73);
    
    --WB
    writeData <= MEM_WB(65 downto 34) when MEM_WB(0) = '0' else MEM_WB(33 downto 2);
    
    connectIFetch: IFetch port map(en, rst, pcsrc, jump, jumpAddress, branchAddress, pcPlus4, instr);
    connectIDecoder: IDecoder port map(en, rwrite, Ext_Op, instr_ID(25 downto 0), writeData, writeAddress_ID, rd1, rd2, rt, rd, ext_imm, func, sa);
    connectUC: UC port map(instr_UC(31 downto 26), rdest, Ext_Op_UC, ALUSrc, BranchOnEqual, BranchNotEqual, BranchGreaterThanZero, jump_UC, ALUOp, MemWrite, MemtoReg, rwrite_UC);
    connectExUnit: EXUnit port map(rd1_EX, rd2_EX, Ext_Imm_EX, ALUSrc_EX, sa_EX, func_EX, ALUOp_EX, pcPlus4_EX, rt_EX, rd_EX, rdest_EX, be, bne, bgtz, branchAddress_EX, ALURes_EX, rWA);
    connectMEM: MEM port map(en, MemWrite_MEM, ALUResIn_MEM, rd2_MEM, MemData_MEM, ALUResOut_MEM);
    
    selectDisplaySSD:process(clk, sw(7 downto 5))
                  begin
                    case sw(7 downto 5) is
                        when "000" => output <= IF_ID(63 downto 32);
                        when "001" => output <= IF_ID(31 downto 0); -- pcPlus4
                        when "010" => output <= ID_EX(77 downto 46); -- rd1
                        when "011" => output <= ID_EX(109 downto 78); -- rd2
                        when "100" => output <= ID_EX(146 downto 115); -- Ext_Imm
                        when "101" => output <= EX_MEM(72 downto 41); -- ALURes
                        when "110" => output <= EX_MEM(72 downto 41); -- MemWrite
                        when "111" => output <= WriteData;
                        when others => output <= x"FFFFFFFF";
                    end case;
                  end process;
                  
    led(0) <= Rdest;
    led(1) <= Ext_OP_UC;
    led(2) <= ALUSrc;
    led(3) <= BranchOnEqual;
    led(4) <= BranchNotEqual;
    led(5) <= BranchGreaterThanZero;
    led(6) <= Jump_UC;
    led(12 downto 7) <= ALUOp;
    led(13) <= MemWrite;
    led(14) <= MemtoReg;
    led(15) <= RWrite_UC;
    
    connectSSD: SSD port map(output, clk, an, cat);
end Behavioral;