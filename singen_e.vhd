LIBRARY ieee;
USE ieee.STD_LOGIC_1164.ALL;
USE ieee.NUMERIC_STD.ALL;

ENTITY singen_e IS

generic (
    reg_width_c : integer := 8;
    sine_resy_c : integer := 8 
  );
  
PORT(clk_i     : IN  std_logic; --! clock
     rst_n_i   : IN  std_logic; --! reset
     reg01_i   : IN  std_logic_vector(reg_width_c-1 DOWNTO 0); --! coef 1
     reg02_i   : IN  std_logic_vector(reg_width_c-1 DOWNTO 0); --! coef 2
     reg03_i   : IN  std_logic_vector(reg_width_c-1 DOWNTO 0); --! coef 3
     reg04_i   : IN  std_logic_vector(reg_width_c-1 DOWNTO 0); --! coef 4
     reg05_i   : IN  std_logic_vector(reg_width_c-1 DOWNTO 0); --! coef 5
     reg06_i   : IN  std_logic_vector(reg_width_c-1 DOWNTO 0); --! coef 6
     reg07_i   : IN  std_logic_vector(reg_width_c-1 DOWNTO 0); --! coef 7
     reg08_i   : IN  std_logic_vector(reg_width_c-1 DOWNTO 0); --! coef 8
     reg09_i   : IN  std_logic_vector(reg_width_c-1 DOWNTO 0); --! freq.
     sine_o    : out std_logic_vector(sine_resy_c-1 DOWNTO 0)  --! sine out
     

     );
END singen_e;
