---------------------------------------------------------------------------------------------------
---- Politecnico Di Milano
---- Carmine Faino
---- Codice persona: 10696112
---- Codice matricola: 932495
---- Progetto di Reti Logiche AA 2021-2022
---------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity project_reti_logiche is
    port (
    i_clk : in std_logic;
    i_rst : in std_logic;
    i_start : in std_logic;
    i_data : in std_logic_vector(7 downto 0);
    o_address : out std_logic_vector(15 downto 0);
    o_done : out std_logic;
    o_en : out std_logic;
    o_we : out std_logic;
    o_data : out std_logic_vector (7 downto 0));
end project_reti_logiche;

architecture Behavioral of project_reti_logiche is
component datapath is
    Port (
        i_clk : in std_logic;
        i_rst : in std_logic;
        i_reset : in std_logic;
        i_data : in std_logic_vector(7 downto 0);
        o_address : out std_logic_vector(15 downto 0);
        o_data : out std_logic_vector (7 downto 0);
        W_load : in std_logic;
        Z_load : in std_logic;
        cont1_sel : in std_logic;
        cont1_load : in std_logic;
        o_end : out std_logic;
        address_sel : in std_logic;
        address_load : in std_logic;
        contTot_load : in std_logic;
        cont2_sel : in std_logic;
        cont2_load : in std_logic;
        U_load : in std_logic;
        Y_load : in std_logic;
        i_we : in std_logic;
        quattrobit : out std_logic;
        temp_load : in std_logic;
        i_done : out std_logic); 
end component;

signal i_reset : std_logic;
signal W_load : std_logic;
signal Z_load : std_logic;
signal cont1_sel : std_logic;
signal cont1_load : std_logic;
signal o_end : std_logic;
signal address_sel : std_logic;
signal address_load : std_logic;
signal contTot_load : std_logic;
signal cont2_sel : std_logic;
signal cont2_load : std_logic;
signal U_load : std_logic;
signal Y_load : std_logic;
signal i_we : std_logic;
signal quattrobit : std_logic;
signal i_done : std_logic;
signal temp_load : std_logic;

type S is (S0,S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,S12,S13,S14,S15);
signal cur_state, next_state : S;

begin
    DATAPATH0: datapath port map(
        i_clk,
        i_rst,
        i_reset,
        i_data,
        o_address,
        o_data,
        W_load,
        Z_load,
        cont1_sel,
        cont1_load,
        o_end,
        address_sel,
        address_load,
        contTot_load,
        cont2_sel,
        cont2_load,
        U_load,
        Y_load,
        i_we,
        quattrobit,
        temp_load,
        i_done
    );

    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            cur_state <= S0;
        elsif rising_edge(i_clk) then
            cur_state <= next_state;
        end if;
      end process;

    process(cur_state, i_start, o_end, quattrobit, i_rst)
    begin
        next_state <= cur_state;
        case cur_state is
            when S0 =>
                if i_rst = '0' then
                    next_state <= S1;
                end if;
            when S1 =>
                if i_start = '1' then
                    next_state <= S2;
                end if;
            when S2 =>
                next_state <= S3;
            when S3 =>
                next_state <= S4;
            when S4 =>
                if i_done = '1' then
                    next_state <= S13;
                else
                    next_state <= S5;
                end if;
            when S5 =>
                next_state <= S6;
            when S6 =>
                next_state <= S7;
            when S7 =>
                next_state <= S8;
            when S8 =>
                next_state <= S9;
            when S9 =>
                next_state <= S10;
            when S10 =>
                if (o_end = '1') or (quattrobit = '1') then
                    next_state <= S11;
                else
                    next_state <= S7;
                end if;
            when S11 =>
                next_state <= S12;
            when S12 =>
                if (o_end = '1' and i_done = '0') then
                    next_state <= S4;
                elsif(o_end = '0' and i_done = '0') then
                    next_state <= S7;
                else 
                    next_state <= S13;
                end if;
            when S13 =>
                next_state <= S14;
            when S14 =>
                if i_start = '0' then
                    next_state <= S15;
                end if;
            when S15 =>
               if i_start = '1' then
                    next_state <= S2;
               end if;
        end case;
    end process;

    process(cur_state)
    begin
        i_reset <= '0';
        W_load <= '0';
        Z_load <= '0';
        cont1_sel <= '1';
        cont1_load <= '0';
        address_sel <= '1';
        address_load <= '0';
        contTot_load <= '0';
        cont2_sel <= '1';
        cont2_load <= '0';
        o_en <= '1';
        o_we <= '0';
        U_load <= '0';
        Y_load <= '0';
        i_we <= '0';
        temp_load <= '0';
        o_done <= '0';
        
        case cur_state is
            when S0 =>
            when S1 =>
            when S2 =>
                contTot_load <= '1';
            when S3 =>
                cont2_sel <= '0';
                cont2_load <= '1';
                address_sel <= '0';
                address_load <= '1';
            when S4 =>
                cont2_load <= '1';
                cont1_sel <= '0';
                cont1_load <= '1';
            when S5 =>
            when S6 =>
                W_load <= '1';
            when S7 =>
                cont1_load <= '1';
            when S8 =>
                cont1_sel <= '1';
                U_load <= '1';
            when S9 =>
                Y_load <= '1';
            when S10 =>
                temp_load <= '1';
            when S11 =>
                Z_load <= '1';
            when S12 =>
                o_we <= '1';
                i_we <= '1';
                address_load <= '1';
            when S13 =>
            when S14 =>
                o_done <= '1';
            when S15 =>
                o_done <= '0';
                i_reset <= '1';
        end case;
    end process;
                
end Behavioral;

--DATAPATH-----------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Datapath is
    Port (
        i_clk : in std_logic;
        i_rst : in std_logic;
        i_reset : in std_logic;
        i_data : in std_logic_vector(7 downto 0);
        o_address : out std_logic_vector(15 downto 0);
        o_data : out std_logic_vector (7 downto 0);
        W_load : in std_logic;
        Z_load : in std_logic;
        cont1_sel : in std_logic;
        cont1_load : in std_logic;
        o_end : out std_logic;
        address_sel : in std_logic;
        address_load : in std_logic;
        contTot_load : in std_logic;
        cont2_sel : in std_logic;
        cont2_load : in std_logic;
        U_load : in std_logic;
        Y_load : in std_logic;
        i_we : in std_logic;
        quattrobit : out std_logic;
        temp_load : in std_logic;
        i_done : out std_logic);
end Datapath;

architecture Behavioral of Datapath is
    signal W : std_logic_vector (7 downto 0);
    signal Z : std_logic_vector (7 downto 0);

    signal sum1 : std_logic_vector(3 downto 0);
    signal regCont1 : std_logic_vector(3 downto 0);
    signal mux1 : std_logic_vector(3 downto 0);

    signal regAddress : std_logic_vector(15 downto 0);
    signal sum2 : std_logic_vector(15 downto 0);
    signal mux2 : std_logic_vector(15 downto 0);

    signal regCont2 : std_logic_vector(7 downto 0);
    signal sum3 : std_logic_vector(7 downto 0);

    signal mux3 : std_logic_vector(15 downto 0);

    signal mux4 : std_logic_vector(7 downto 0);

    signal regContTot : std_logic_vector(7 downto 0);

    signal U : std_logic;
    signal Y : std_logic_vector(1 downto 0);
    signal temp1 :std_logic_vector(1 downto 0);
    signal temp2 :std_logic_vector(1 downto 0);
    signal temp3 :std_logic_vector(1 downto 0);
    signal temp4 : std_logic_vector(1 downto 0);
    signal stato_corr : std_logic_vector(1 downto 0);


    begin
        process(i_clk, i_rst)
        begin
            if(i_rst = '1' or i_reset = '1') then
                W <= "00000000";
                regContTot <= "00000000";
            elsif rising_edge(i_clk) then
                if(W_load = '1') then
                    W <= i_data;
                elsif(contTot_load = '1') then
                    regContTot <= i_data;
                end if;
            end if;
        end process;

        process(i_clk, i_rst)
        begin
            if(i_rst = '1' or i_reset = '1') then
                Z <= "00000000";
            elsif rising_edge(i_clk) then
                if(Z_load = '1') then
                    Z <= temp1 & temp2 & temp3 & temp4;
                end if;
            end if;
        end process;

        o_data <= Z;

        sum1 <= regCont1 + 0001;

        process(i_clk, i_rst)
        begin
            if(i_rst = '1' or i_reset = '1') then
                regCont1 <= "0000";
            elsif rising_edge(i_clk) then
                if(cont1_load = '1') then
                    regCont1 <= mux1;
                end if;
            end if;
        end process;

        with cont1_sel select
            mux1 <= "0000" when '0',
                        sum1 when '1',
                        "XXXX" when others;
                        
        quattrobit <= '1' when (regCont1 = 4) else '0';
        o_end <= '1' when (regCont1 = 8) else '0';          

        process(i_clk, i_rst)
        begin
            if(i_rst = '1' or i_reset = '1') then
                regAddress <= "0000000000000000";
            elsif rising_edge(i_clk) then
                if(address_load = '1') then
                    regAddress <= mux2;
                end if;
            end if;
        end process;

        sum2 <= regAddress + 0000000000000001;

        with address_sel select
            mux2 <= "0000001111101000" when '0',
                        sum2 when '1',
                        "XXXXXXXXXXXXXXXX" when others;

        process(i_clk, i_rst)
        begin
            if(i_rst = '1' or i_reset = '1') then
                regCont2 <= "00000000";
            elsif rising_edge(i_clk) then
                if(cont2_load = '1') then
                    regCont2 <= mux4;
                end if;
            end if;
        end process;

        sum3 <= regCont2 + "00000001";

        with cont2_sel select
            mux4 <= "00000000" when '0',
                        sum3 when '1',
                        "XXXXXXXX" when others;

        with i_we select
            mux3 <= "00000000" & regCont2 when '0',
                    regAddress when '1',
                    "XXXXXXXXXXXXXXXX" when others;
        
        o_address <= mux3;

        i_done <= '1' when ((regCont2 = regContTot and regCont1 = 8) or regContTot = 0) else '0';

        process(i_clk, i_rst)
        begin
            if(i_rst = '1' or i_reset = '1') then
                U <= '0';
            elsif rising_edge(i_clk) then
                if(U_load = '1') then
                    if(regCont1 = 1) then
                        U <= W(7);
                    elsif (regCont1 = 2) then
                        U <= W(6);
                    elsif (regCont1 = 3) then
                        U <= W(5);
                    elsif (regCont1 = 4) then
                        U <= W(4);
                    elsif (regCont1 = 5) then
                        U <= W(3);
                    elsif (regCont1 = 6) then
                         U <= W(2);
                    elsif (regCont1 = 7) then
                        U <= W(1);
                    elsif (regCont1 = 8) then 
                        U <= W(0);
                    end if;
                end if;
            end if;
        end process;

        process(i_clk, i_rst)
        begin
            if(i_rst = '1' or i_reset = '1') then
                stato_corr <= "00";
                Y <= "XX";
            elsif rising_edge(i_clk) then
                if(Y_load = '1') then
                    Y <= (U xor stato_corr(0)) & ((not(U) and (stato_corr(0) xor stato_corr(1))) or (U and (stato_corr(1) xor not(stato_corr(0)))));
                    stato_corr <= U & stato_corr(1);
                end if;
            end if;
        end process;

        process(i_clk, i_rst)
        begin
            if(i_rst = '1' or i_reset = '1') then
                temp1 <= "00";
            elsif rising_edge(i_clk) then
                if temp_load = '1' and (regCont1 = 1 or regCont1 = 5) then
                    temp1 <= Y;
                end if;
            end if;
        end process;

        process(i_clk, i_rst)
        begin
            if(i_rst = '1' or i_reset = '1') then
                temp2 <= "00";
            elsif rising_edge(i_clk) then
                if temp_load = '1' and (regCont1 = 2 or regCont1 = 6) then
                    temp2 <= Y;
                end if;
            end if;
        end process;

        process(i_clk, i_rst)
        begin
            if(i_rst = '1' or i_reset = '1') then
                temp3 <= "00";
            elsif rising_edge(i_clk) then
                if temp_load = '1' and (regCont1 = 3 or regCont1 = 7) then
                    temp3 <= Y;
                end if;
            end if;
        end process;

        process(i_clk, i_rst)
        begin
            if(i_rst = '1' or i_reset = '1') then
                temp4 <= "00";
            elsif rising_edge(i_clk) then
                if temp_load = '1' and (regCont1 = 4 or regCont1 = 8) then
                    temp4 <= Y;
                end if;
            end if;
        end process;
        
end Behavioral;