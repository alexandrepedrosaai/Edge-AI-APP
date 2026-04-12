library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_top is
end tb_top;

architecture sim of tb_top is
    signal clk     : std_logic := '0';
    signal reset_n : std_logic := '0';
    signal button  : std_logic_vector(1 downto 0) := "00";
    signal led     : std_logic_vector(1 downto 0);

    component top_entity
        Port (
            clk     : in  STD_LOGIC;
            reset_n : in  STD_LOGIC;
            button  : in  STD_LOGIC_VECTOR(1 downto 0);
            led     : out STD_LOGIC_VECTOR(1 downto 0)
        );
    end component;
begin
    uut: top_entity port map (
        clk     => clk,
        reset_n => reset_n,
        button  => button,
        led     => led
    );

    -- Clock generation: 50 MHz (20 ns period)
    clk_process: process
    begin
        while true loop
            clk <= '0'; wait for 10 ns;
            clk <= '1'; wait for 10 ns;
        end loop;
    end process;

    -- Stimulus
    stim_proc: process
    begin
        reset_n <= '0'; wait for 20 ns;
        reset_n <= '1'; wait for 20 ns;

        button <= "01"; wait for 40 ns;
        button <= "10"; wait for 40 ns;
        button <= "11"; wait for 40 ns;
        button <= "00"; wait for 40 ns;

        assert false report "Simulation complete." severity note;
        wait;
    end process;
end sim;
