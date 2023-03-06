library ieee;
use ieee.std_logic_1164.all;

entity traffic_light is
	port(
		clk, reset: in std_logic;
		rc, yc, gc, rp, gp: out std_logic;
		time_d1, time_d2: out integer
	);
end traffic_light;

architecture Behaviorial of traffic_light is

    type State_t is (redRed1, redGreen, redRed2, redYellowRed, greenRed, yellowRed);
    signal state_reg, next_state : State_t;
	
	constant TIME_MAX: integer := 22;
	constant CLOCK: integer := 8;
	signal timeout_cnt: integer range 0 to 22*CLOCK := 2*CLOCK;
	
	constant RED_RED_TIME: integer := 2*CLOCK;
	constant RED_GREEN_TIME: integer := 9*CLOCK;
	constant RED_YELLOW_RED_TIME: integer := 1*CLOCK;
	constant GREEN_RED_TIME: integer := 22*CLOCK;
	constant YELLOW_RED_TIME: integer := 1*CLOCK;
	
begin

    STATE_TRANSITION: process (clk) is
    begin
        if rising_edge(clk) then
            if reset = '1' then
                state_reg <= redRed1;
            else
                state_reg <= next_state;
            end if;
        end if;
    end process STATE_TRANSITION;
	
	NEXT_STATE_LOGIC: process(state_reg, timeout_cnt) is
	begin 
		case (state_reg) is
			when redRed1 => 
				if (timeout_cnt = 1) then
					next_state <= redGreen;
				else
					next_state <= redRed1;
				end if;
			when redGreen => 
				if (timeout_cnt = 1) then
					next_state <= redRed2;
				else
					next_state <= redGreen;
				end if;
			when redRed2 => 
				if (timeout_cnt = 1) then
					next_state <= redYellowRed;
				else
					next_state <= redRed2;
				end if;
			when redYellowRed => 
				if (timeout_cnt = 1) then
					next_state <= greenRed;
				else
					next_state <= redYellowRed;
				end if;
			when greenRed => 
				if (timeout_cnt = 1) then
					next_state <= yellowRed;
				else
					next_state <= greenRed;
				end if;
			when yellowRed => 
				if (timeout_cnt = 1) then
					next_state <= redRed1;
				else
					next_state <= yellowRed;
				end if;
		end case;
	end process NEXT_STATE_LOGIC;
	
    TIMEOUT_PROC: process (clk, timeout_cnt) is
    begin
        if rising_edge(clk) then
			if timeout_cnt > 1 then
				timeout_cnt <= timeout_cnt - 1;
			else 
				case state_reg is
					when redRed1 =>
						timeout_cnt <= RED_GREEN_TIME;
					when redGreen =>
						timeout_cnt <= RED_RED_TIME;
					when redRed2 => 
						timeout_cnt <= RED_YELLOW_RED_TIME;
					when redYellowRed =>
						timeout_cnt <= GREEN_RED_TIME;
					when greenRed =>
						timeout_cnt <= YELLOW_RED_TIME;
					when yellowRed =>
						timeout_cnt <= RED_RED_TIME;
				end case;
			end if;
        end if;
    end process TIMEOUT_PROC;
	
	OUTPUT_LOGIC: process(state_reg, timeout_cnt) is
		variable p_d1: integer range 0 to 10;
		variable p_d2: integer range 0 to 10;
	begin
		case state_reg is
			when redRed1 => 
				rc <= '1';
				yc <= '0';
				gc <= '0';
				rp <= '1';
				gp <= '0';
			when redGreen =>
				rc <= '1';
				yc <= '0';
				gc <= '0';
				rp <= '0';
				gp <= '1';
			when redRed2 =>
				rc <= '1';
				yc <= '0';
				gc <= '0';
				rp <= '1';
				gp <= '0';
			when redYellowRed =>
				rc <= '1';
				yc <= '1';
				gc <= '0';
				rp <= '1';
				gp <= '0';
			when greenRed =>
				rc <= '0';
				yc <= '0';
				gc <= '1';
				rp <= '1';
				gp <= '0';
			when yellowRed =>
				rc <= '0';
				yc <= '1';
				gc <= '0';
				rp <= '1';
				gp <= '0';
		end case;
		if (state_reg = greenRed) then
			if (timeout_cnt mod CLOCK = 0) then
				if(timeout_cnt/CLOCK >= 10) then
					time_d2 <= (timeout_cnt/CLOCK - 1) mod 10;
					p_d2 := (timeout_cnt/CLOCK - 1) mod 10;
					time_d1 <= (timeout_cnt/CLOCK - 1) / 10;
					p_d1 := (timeout_cnt/CLOCK - 1) / 10;
					if(((timeout_cnt/CLOCK - 1) / 10) = 0) then
						time_d1 <= 10;
						p_d1 := 10;
					end if;
				else
					time_d1 <= 10;
					p_d1 := 10; 
					time_d2 <= timeout_cnt/CLOCK - 1;
					p_d2 := timeout_cnt/CLOCK - 1;
				end if;
			else
				time_d1 <= p_d1;
				time_d2 <= p_d2;
			end if;
		else
			time_d1 <= 10;
			time_d2 <= 10;
		end if;
	end process OUTPUT_LOGIC;
	
end architecture Behaviorial;
