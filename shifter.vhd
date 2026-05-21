library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity shivfter is
    port (
        R : in std_logic_vector(7 downto 0);
        G : in std_logic_vector(7 downto 0);
        B : in std_logic_vector(7 downto 0);
        Rrhf : out std_logic_vector(7 downto 0);
        Grhf : out std_logic_vector(7 downto 0);
        Brhf : out std_logic_vector(7 downto 0)
    );
    end shivfter;

architecture Behavioral of shivfter is
begin
    Rrhf <= STD_LOGIC_VECTOR(SHIFT_RIGHT(unsigned(R), 2));
    Grhf <= STD_LOGIC_VECTOR(SHIFT_RIGHT(unsigned(G), 1));
    Brhf <= STD_LOGIC_VECTOR(SHIFT_RIGHT(unsigned(B), 2));
end Behavioral;
