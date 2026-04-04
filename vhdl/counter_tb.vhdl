-- Testbench for counter in VHDL
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter_tb is
end counter_tb;

architecture Behavioral of counter_tb is
    signal clk   : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '1';
    signal count : STD_LOGIC_VECTOR (3 downto 0);

    component counter
        Port (
            clk   : in  STD_LOGIC;
            reset : in  STD_LOGIC;
            count : out STD_LOGIC_VECTOR (3 downto 0)
        );
    end component;

begin
    uut: counter port map (
        clk => clk,
        reset => reset,
        count => count
    );

    clk_process : process
    begin
        while true loop
            clk <= not clk;
            wait for 5 ns;
        end loop;
    end process;

    stim_proc: process
    begin
        wait for 10 ns;
        reset <= '0';
        wait for 100 ns;
        assert false report "Simulation finished" severity failure;
    end process;
end Behavioral;
