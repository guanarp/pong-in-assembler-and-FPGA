--Josias Grau Figueredo

--Este mux nos ayuda a acceder a la memoria utilizando las entradas que le
--pasemos en numeros enteros

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux_memoria_video is
    Port ( 
			  dir_controlador : in integer range 0 to 1023;
           dir_acceso : in integer range 0 to 1023;
           sel_leerOescribir : in  STD_LOGIC; --'1' va a ser escribir o leer '0' para mostrar nomas la pantalla
           dir_out : out integer range 0 to 1023
			  );
end Mux_memoria_video;

architecture Behavioral of Mux_memoria_video is

begin
	dir_out <= 	dir_acceso when sel_leerOescribir = '1' else
					dir_controlador;
end Behavioral;

