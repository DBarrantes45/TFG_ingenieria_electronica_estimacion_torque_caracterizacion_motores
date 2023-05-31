% -------------------------------------------------------------------------
% PRUEBA_DC
%
% Esta función calcula la resistencia del estator a 95 °C a partir de los
% valores de resistencia medidos a 20 °C y utilizando el coeficiente de
% temperatura del cobre a 20°C.
%
% Salida:
%   - Resistencia_estator_95_grados: Resistencia del estator a 95 °C (ohmios)
%
% Escrito por Douglas Barrantes Alfaro
% Fecha: mayo 2023
% -------------------------------------------------------------------------

function [Resistencia_estator_95_grados] = prueba_dc ()
    % Variables iniciales
    % Resistencia del estator medida a 20 °C
    Resistencia_estator_20_grados = [7.786941721, 18.39606061];
    % Coeficiente de temperatura del cobre a 20°C
    alpha = 3.9*10^(-3);

    % Cálculo de la resistencia a 95 °C
    % Se utiliza la fórmula de la resistencia con respecto a la temperatura para extrapolar los datos
    for i = 1:length(Resistencia_estator_20_grados)
        Resistencia = Resistencia_estator_20_grados(i);
        Resistencia_estator_95_grados(i) = Resistencia * (1 + alpha * (95 - 20));
    end
end

