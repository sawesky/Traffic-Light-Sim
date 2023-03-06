library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.numeric_std.all;
use IEEE.std_logic_textio.all; 


entity traffic_light_system is
        port (
            clk         : in std_logic;
            reset       : in std_logic;
            display1    : out std_logic_vector(6 downto 0);
            display0    : out std_logic_vector(6 downto 0);
            rc, yc, gc, rp, gp : out std_logic    
        );
end traffic_light_system;

architecture Structural of traffic_light_system is

	--signal clk : std_logic := '1';
	--signal reset : std_logic;
	--signal rc, yc, gc, rp, gp : std_logic;
	signal time_d1, time_d2 : integer;

	component traffic_light is 
		port (
			clk					: in std_logic;
			reset			    : in std_logic;
			rc, yc, gc, rp, gp  : out std_logic;
			time_d2, time_d1    : out integer
		);
	end component;
	
	component bcd_to_7seg is 
		port (
			digit 	: in integer;
			display : out std_logic_vector(6 downto 0)
		);
	end component;
	
begin

	TL_INST : traffic_light port map (clk, reset, rc, yc, gc, rp, gp, time_d1, time_d2);
	
	BCD7SEG_INST1 : bcd_to_7seg port map (time_d1, display0);
	BCD7SEG_INST2 : bcd_to_7seg port map (time_d2, display1);
	
	

end architecture Structural;