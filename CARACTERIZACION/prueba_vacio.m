% -------------------------------------------------------------------------
% PRUEBA_VACIO
%
% Esta función calcula la reactancia de magnetización (X_M), el error de potencia
% (error_potencia) y la resistencia del núcleo (R_nucleo) a partir de varias mediciones
% y parámetros predefinidos de la máquina.
%
% Entradas:
%   - I_A, I_B, I_C: Corrientes de línea (A)
%   - V_AB, V_BC, V_CA: Voltajes de línea (V)
%   - P_entrada: Potencia de entrada (W)
%   - X_1, R_1: Reactancia y resistencia del estator (ohmios)
%   - P_nucleo: Pérdidas en el núcleo (W)
%   - P_FyR: Pérdidas por fricción y rozamiento (W)
%   - FP: Factor de potencia
%
% Salidas:
%   - X_M: Reactancia de magnetización (ohmios)
%   - error_potencia: Error de potencia
%   - R_nucleo: Resistencia del núcleo (ohmios)
%
% Escrito por Douglas Barrantes Alfaro
% Fecha: mayo 2023
% -------------------------------------------------------------------------

function [X_M, error_potencia, R_nucleo] = prueba_vacio (I_A, I_B, I_C, V_AB, V_BC, V_CA, P_entrada, X_1, R_1, P_nucleo, P_FyR, FP)
    % Variables Iniciales
    % Corriente de línea promedio medida (A)
    I_L = (I_A + I_B + I_C)/3;
    % Voltajes promedio medidos (V)
    V_L = (V_AB + V_BC + V_CA)/3;
    % Cálculo del V_phi (voltaje nominal 220V)
    V_phi = V_L;

    % Cálculo de la reactancia de magnetización
    Z_eq = V_phi / I_L;
    X_M = Z_eq - X_1;

    % Comprobación de las variables medidas
    % Cálculo de P_SCL
    P_SCL = 3 * (I_L)^(2) * R_1;
    P_entrada_estimada = P_nucleo + P_SCL + P_FyR;
    error_potencia = (P_entrada_estimada - P_entrada)/(P_entrada);

    % Cálculo de la resistencia del núcleo
    % Cálculo de la impedancia del estator
    Z_1 = R_1 + 1i*X_1;
    % Cálculo de theta
    theta = acos(FP);
    % Cálculo de I_1
    fase_rad = deg2rad(theta);
    I_1 = I_L * (cos(fase_rad) + 1i*sin(theta)); % Aquí estaba la corriente nominal
    % Cálculo de E_1
    E_1 = V_phi - (I_1 * Z_1);
    E_1 = abs(E_1);
    % Resistencia del núcleo
    R_nucleo = (3 * (E_1)^(2)) / (P_nucleo);
end

