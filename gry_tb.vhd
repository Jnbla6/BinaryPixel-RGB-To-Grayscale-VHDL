library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all; -- Required for file streaming

entity gry_tb is
-- Testbenches have empty ports
end gry_tb;

architecture Sim of gry_tb is
    -- Signals connecting directly to your system ports
    signal R_in     : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal G_in     : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal B_in     : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal Gray_out : STD_LOGIC_VECTOR(7 downto 0);
begin

    -- Instantiate your system wrapper
    UUT: entity work.rgb_to_gray_system
        port map (
            R_in     => R_in,
            G_in     => G_in,
            B_in     => B_in,
            Gray_out => Gray_out
        );

    -- File processing engine
    process
        file infile       : text open read_mode  is "input_pixels.txt";
        file outfile      : text open write_mode is "output_pixels.txt";
        variable inline   : line;
        variable outline  : line;
        
        variable r_val, g_val, b_val : integer;
        variable width, height       : integer;
    begin
        -- Read image header configurations (width & height)
        if not endfile(infile) then
            readline(infile, inline);
            read(inline, width);
            read(inline, height);
            
            -- Mirror the header to the output results file
            write(outline, width);
            write(outline, ' ');
            write(outline, height);
            writeline(outfile, outline);
        end if;

        -- Loop through every single pixel from the Python data stream
        while not endfile(infile) loop
            readline(infile, inline);
            read(inline, r_val);
            read(inline, g_val);
            read(inline, b_val);

            -- Push values into your shifter and adders
            R_in <= std_logic_vector(to_unsigned(r_val, 8));
            G_in <= std_logic_vector(to_unsigned(g_val, 8));
            B_in <= std_logic_vector(to_unsigned(b_val, 8));
            
            wait for 10 ns; -- Clock cycle simulation for propagation delay

            -- Write the hardware output byte back to text
            write(outline, to_integer(unsigned(Gray_out)));
            writeline(outfile, outline);
        end loop;

        file_close(infile);
        file_close(outfile);
        wait; -- Halt simulation safely
    end process;

end Sim;