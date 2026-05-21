library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity gryadder is
    Port (
        a    : in  STD_LOGIC_vector(7 downto 0);
        b    : in  STD_LOGIC_vector(7 downto 0);
        cin  : in  STD_LOGIC;
        sum  : out STD_LOGIC_vector(7 downto 0);
        cout : out STD_LOGIC
    );
end gryadder;

architecture Behavioral of gryadder is
begin
    process(a, b, cin)
    variable temp : STD_LOGIC;
    begin
        temp := cin;

        for i in 0 to 7 loop
            sum(i) <= a(i) XOR b(i) XOR temp;
            temp := (a(i) AND b(i)) OR (b(i) AND temp) OR (a(i) AND temp);
        end loop;

        cout <= temp;

    end process;
end Behavioral;
