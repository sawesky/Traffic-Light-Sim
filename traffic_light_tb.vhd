library ieee;
use ieee.std_logic_1164.all;

entity traffic_light_tb is
end traffic_light_tb;

architecture Test of traffic_light_tb is
	
	component traffic_light is
	port(
		clk, reset: in std_logic;
		rc, yc, gc, rp, gp: out std_logic;
		time_d1, time_d2: out integer
	);
	end component;
	
	constant C_CLK_PERIOD: time := 125 ms;
	
	signal clk : std_logic := '1';
	signal reset, rc, yc, gc, rp, gp: std_logic;
	signal time_d1, time_d2: integer;

begin
	TRAFFIC_LIGHT1: traffic_light port map(clk, reset, rc, yc, gc, rp, gp, time_d1, time_d2);
	
	clk <= not clk after C_CLK_PERIOD/2;

	STIMULUS: process
	begin
		reset <= '0';
		wait;
	end process STIMULUS;
	
end architecture Test;
