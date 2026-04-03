library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Top-level entity for Edge-AI-APP FPGA design
-- Supports Intel Cyclone V and Xilinx Artix-7
entity top_entity is
    Port (
        clk      : in  STD_LOGIC;
        reset_n  : in  STD_LOGIC;
        button   : in  STD_LOGIC_VECTOR(1 downto 0);
        led      : out STD_LOGIC_VECTOR(1 downto 0)
    );
end top_entity;

architecture rtl of top_entity is
    signal counter : unsigned(23 downto 0) := (others => '0');
begin
    process(clk, reset_n)
    begin
        if reset_n = '0' then
            counter <= (others => '0');
            led     <= "00";
        elsif rising_edge(clk) then
            counter <= counter + 1;
            case button is
                when "01"   => led <= "01";
                when "10"   => led <= "10";
                when "11"   => led <= "11";
                when others => led <= std_logic_vector(counter(23 downto 22));
            end case;
        end if;
    end process;
end rtl;
