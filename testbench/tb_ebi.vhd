LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY tb_ebi IS
END tb_ebi;
 
ARCHITECTURE behavior OF tb_ebi IS
   
   component ebi
   port(
     data_in : in std_logic_vector(15 downto 0);
     address_in : in std_logic_vector(18 downto 0);
     write_enable_in : in std_logic;
     read_enable_in : in std_logic;
     chip_select_fpga_in : in std_logic;
     chip_select_sram_in : in std_logic;
     clk : in std_logic;
     reset : in std_logic;
     led_1 : out std_logic;
     led_2 : out std_logic;
     led_3 : out std_logic
   );
   end component;

   --Inputs
   signal data_in : std_logic_vector(15 downto 0) := (others => '0');
   signal address_in : std_logic_vector(18 downto 0) := (others => '0');
   signal write_enable_in : std_logic := '0';
   signal read_enable_in : std_logic := '0';
   signal chip_select_fpga_in : std_logic := '0';
   signal chip_select_sram_in : std_logic := '0';
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';

 	--Outputs
   signal led_1 : std_logic;
   signal led_2 : std_logic;
   signal led_3 : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ebi PORT MAP (
          data_in => data_in,
          address_in => address_in,
          write_enable_in => write_enable_in,
          read_enable_in => read_enable_in,
          chip_select_fpga_in => chip_select_fpga_in,
          chip_select_sram_in => chip_select_sram_in,
          clk => clk,
          reset => reset,
          led_1 => led_1,
          led_2 => led_2,
          led_3 => led_3
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;
      
      data_in <= x"0000";
      
      wait for clk_period;
      
      assert led_1 = '0' report "outrage" severity failure;
      assert led_2 = '1' report "outrage" severity failure;
      
      data_in <= x"ffff";
      
      wait for clk_period;
      
      assert led_1 = '1' report "outrage" severity failure;
      assert led_2 = '0' report "outrage" severity failure;
      
      report "complete";

      wait;
   end process;

END;
