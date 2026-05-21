library IEEE;
use IEEE.std_logic_1164.all;

entity rgb_to_gray_system is
    Port (
        R_in     : in  STD_LOGIC_VECTOR(7 downto 0);
        G_in     : in  STD_LOGIC_VECTOR(7 downto 0);
        B_in     : in  STD_LOGIC_VECTOR(7 downto 0);
        Gray_out : out STD_LOGIC_VECTOR(7 downto 0)
    );
end rgb_to_gray_system;

architecture Structural of rgb_to_gray_system is

    signal r_wire, g_wire, b_wire : STD_LOGIC_VECTOR(7 downto 0);
    signal first_sum              : STD_LOGIC_VECTOR(7 downto 0);
    signal carry1, carry2         : STD_LOGIC;

begin

    my_shifter: entity work.shivfter
        port map (
            R    => R_in,
            G    => G_in,
            B    => B_in,
            Rrhf => r_wire,
            Grhf => g_wire,
            Brhf => b_wire
        );

    adder_RB: entity work.gryadder
        port map (
            a    => r_wire,
            b    => b_wire,
            cin  => '0',
            sum  => first_sum,
            cout => carry1
        );

    adder_Final: entity work.gryadder
        port map (
            a    => first_sum,
            b    => g_wire,
            cin  => '0',
            sum  => Gray_out,
            cout => carry2
        );

end Structural;