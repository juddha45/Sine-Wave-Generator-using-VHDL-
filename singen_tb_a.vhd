
ARCHITECTURE singen_tb_a OF singen_tb_e IS 

       -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT singen_e
        GENERIC (
            reg_width_c : integer := 8;
            sine_resy_c : integer := 8
        );
        PORT (
            clk_i     : IN  std_logic;
            rst_n_i   : IN  std_logic;
            reg01_i   : IN  std_logic_vector(7 downto 0);
            reg02_i   : IN  std_logic_vector(7 downto 0);
            reg03_i   : IN  std_logic_vector(7 downto 0);
            reg04_i   : IN  std_logic_vector(7 downto 0);
            reg05_i   : IN  std_logic_vector(7 downto 0);
            reg06_i   : IN  std_logic_vector(7 downto 0);
            reg07_i   : IN  std_logic_vector(7 downto 0);
            reg08_i   : IN  std_logic_vector(7 downto 0);
            reg09_i   : IN  std_logic_vector(7 downto 0); -- Frequency control
            sine_o    : OUT std_logic_vector(7 downto 0)
        );
    END COMPONENT;

   -- Inputs
   signal clk_i_s : std_logic := '0';
   signal rst_n_i_s : std_logic := '1';
   type Coeff_Array_Type is array (0 to 7) of std_logic_vector(7 downto 0);
   signal reg_coeffs_s : Coeff_Array_Type := (
       "10000000", "10011000", "10110000", "11000110", "11011010", "11101010", "11110101", "11111101"
      -- "11111111", "11111101", "11110101", "11101010", "11011010", "11000110", "10110000", "10011000",
     --  "10000000", "01100111", "01001111", "00111001", "00100101", "00010101", "00001010", "00000010",
   );
   signal reg09_i_s : std_logic_vector(7 downto 0) := (others => '0');

   -- Outputs
   signal sine_o_s : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 8 ns;

BEGIN

  -- Instantiate the Unit Under Test (UUT)
   uut: sinGen_e
        GENERIC MAP (
            reg_width_c => 8,
            sine_resy_c => 8
        )
        PORT MAP (
          clk_i => clk_i_s,
          rst_n_i => rst_n_i_s,
          reg01_i => reg_coeffs_s(0),
          reg02_i => reg_coeffs_s(1),
          reg03_i => reg_coeffs_s(2),
          reg04_i => reg_coeffs_s(3),
          reg05_i => reg_coeffs_s(4),
          reg06_i => reg_coeffs_s(5),
          reg07_i => reg_coeffs_s(6),
          reg08_i => reg_coeffs_s(7),
          reg09_i => reg09_i_s,
          sine_o => sine_o_s
        );

    -- Clock process definitions
    clk_process :process
    begin
        while true loop
            clk_i_s <= '0';
            wait for clk_period/2;
            clk_i_s <= '1';
            wait for clk_period/2;
        end loop;
    end process;

    -- Stimulus process
    stim_proc: process
    begin       
        -- Initialize Inputs
        rst_n_i_s <= '0';
        wait for  16 ns;
        rst_n_i_s <= '1'; 

        -- Frequency setting
        reg09_i_s <= std_logic_vector(to_unsigned(1000, 8)); 

        -- Cycle through coefficients
        for i in 0 to 7 loop
            reg_coeffs_s(0) <= std_logic_vector(to_unsigned(i, 8)); -- Load new coefficients each cycle
            wait for clk_period * 2; 
            assert to_integer(unsigned(sine_o_s)) = i
                report "Mismatch in amplitude at phase " & integer'image(i)
                severity warning;
        end loop;

        wait;
    end process;


END singen_tb_a;
