ARCHITECTURE singen_a OF singen_e IS

    -- Define the coefficients as an array for ease of use
    type Coeff_Type is array(0 to 7) of std_logic_vector(reg_width_c-1 downto 0);
    signal coeffs_i : Coeff_Type;

    signal phase_acc : integer range 0 to 31 := 0; -- Phase accumulator
    signal timer     : integer := 0;              -- Timer for frequency control

    -- FSM states
    type State_Type is (ST_RESET, ST_WAIT, ST_UPDATE);
    signal state : State_Type := ST_RESET;

BEGIN

    -- Assign input coefficients to the array
    coeffs_i(0) <= reg01_i;
    coeffs_i(1) <= reg02_i;
    coeffs_i(2) <= reg03_i;
    coeffs_i(3) <= reg04_i;
    coeffs_i(4) <= reg05_i;
    coeffs_i(5) <= reg06_i;
    coeffs_i(6) <= reg07_i;
    coeffs_i(7) <= reg08_i;

    -- FSM process for generating the sine wave
    process(clk_i, rst_n_i)
    begin
        if rst_n_i = '0' then
            -- Reset state logic
            state <= ST_RESET;
        elsif rising_edge(clk_i) then
            case state is
                when ST_RESET =>
                    phase_acc <= 0;
                    timer <= 0;
                    sine_o <= (others => '0');
                    state <= ST_WAIT;

                when ST_WAIT =>
                    -- Stay in wait state until timer condition is met
                    if timer = ((125000000 / to_integer(unsigned(reg09_i))) / 32) - 1 then
                        timer <= 0; -- Reset timer and go to update state
                        state <= ST_UPDATE;
                    else
                        timer <= timer + 1; -- Increment timer
                    end if;

                when ST_UPDATE =>
                    -- Update the phase accumulator
                    phase_acc <= (phase_acc + 1) mod 32;

                    -- Calculate sine output based on the current phase
                    if phase_acc < 8 then
                        sine_o <=  std_logic_vector (to_unsigned(128 + to_integer(signed(coeffs_i(phase_acc))), 8));
                    elsif phase_acc < 16 then
                        sine_o <= std_logic_vector (to_unsigned(128 + to_integer(signed(coeffs_i(15 - phase_acc))), 8));
                    elsif phase_acc < 24 then
                        sine_o <= std_logic_vector (to_unsigned(128 - to_integer(signed(coeffs_i(phase_acc - 16))), 8));
                    else
                        sine_o <= std_logic_vector (to_unsigned(128 - to_integer(signed(coeffs_i(31 - phase_acc))), 8));
                    end if;

                    -- Return to wait state after updating
                    state <= ST_WAIT;

            end case;
        end if;
    end process;

END singen_a;
