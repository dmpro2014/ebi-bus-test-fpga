library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ebi is
  Port (data_in : inout  STD_LOGIC_VECTOR (15 downto 0);
        address_in : in  STD_LOGIC_VECTOR (18 downto 0);
        write_enable_in : in  STD_LOGIC;
        read_enable_in : in  STD_LOGIC;
        chip_select_fpga_in : in STD_LOGIC;
        chip_select_sram_in : in STD_LOGIC;
        clk : in  STD_LOGIC;
        reset : in  STD_LOGIC;
        led_1 : out STD_LOGIC;
        led_2 : out STD_LOGIC;
        led_3 : out STD_LOGIC;
        UART_Rx : in STD_LOGIC;
        UART_Tx : out STD_LOGIC);
end ebi;

architecture Behavioral of ebi is

  signal hcDMemWriteEnable : std_logic;
  signal hcDMemWriteData : std_logic_vector(7 downto 0);
  signal hcDmemReadData : std_logic_vector(7 downto 0);
  signal hcDMemAddr : std_logic_vector(9 downto 0);
  
  signal hcIMemReadData : std_logic_vector(7 downto 0);
  signal hcIMemWriteData : std_logic_vector(7 downto 0);
  signal hcIMemWriteEnable : std_logic;
  signal hcIMemAddr : std_logic_vector(9 downto 0);
  
  signal temp_data_in : std_logic_vector(31 downto 0);
  signal temp_data_out : std_logic_vector(31 downto 0);
  
  signal processor_enable : std_logic := '1';
  signal no : std_logic := '0';
  
  signal mem_write_enable : std_logic;

begin

process (data_in) is
begin
  led_1 <= '0';
  led_2 <= '1';

  if data_in = x"ffff" then
    led_1 <= '1';
    led_2 <= '0';
  end if;
end process;

process (write_enable_in) is
begin
  led_3 <= '0';
  
  if write_enable_in = '1' then
    led_3 <= '1';
  end if;
end process;

process (write_enable_in, processor_enable) is
begin
  mem_write_enable <= '0';
  if write_enable_in = '0' and processor_enable = '1' then
    mem_write_enable <= '1';
  end if;
end process;

HostCommInstr: entity work.HostComm port map (
  clk => clk, reset => reset,
  UART_Rx => UART_Rx, UART_Tx => UART_Tx,
  proc_en => processor_enable, proc_rst => no,
  imem_data_in => hcIMemReadData, imem_data_out => hcIMemWriteData,
  imem_wr_en => hcIMemWriteEnable, imem_addr => hcIMemAddr,
  
  dmem_data_in => hcDMemReadData, dmem_data_out => hcDMemWriteData,
  dmem_wr_en => hcDMemWriteEnable, dmem_addr => hcDMemAddr
);

temp_data_in <= x"0000" & data_in;

DataMem: entity work.DualPortMem port map (
  clka => clk, clkb => clk,
  wea(0) => mem_write_enable,
  dina => temp_data_in,
  addra => address_in(7 downto 0),
  douta => temp_data_out,
  web(0) => hcDMemWriteEnable,
  addrb => hcDMemAddr,
  dinb => hcDMemWriteData,
  doutb => hcDMemReadData
);

end Behavioral;