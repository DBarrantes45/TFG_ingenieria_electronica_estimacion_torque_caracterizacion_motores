% -------------------------------------------------------------------------
% PRUEBA_ROTOR_BLOQUEADO
%
% Esta función calcula la resistencia del rotor (R_2) y las reactancias del estator
% y del rotor (X_1 y X_2) a partir de diversas mediciones de la máquina y parámetros predefinidos.
%
% Entradas:
%   - R_1: Resistencia del estator (ohmios)
%   - I_A, I_B, I_C: Corrientes de línea (A)
%   - V_AB, V_BC, V_CA: Voltajes de línea (V)
%   - FP: Factor de potencia
%
% Salidas:
%   - R_2: Resistencia del rotor (ohmios)
%   - X_1: Reactancia del estator (ohmios)
%   - X_2: Reactancia del rotor (ohmios)
%
% Escrito por Douglas Barrantes Alfaro
% Fecha: mayo 2023
% -------------------------------------------------------------------------

function [R_2, X_1, X_2] = prueba_rotor_bloqueado(R_1, I_A, I_B, I_C, V_AB, V_BC, V_CA, FP)
    % Variables iniciales
    % Frecuencia de prueba (Hz)
    f_prueba = 60;
    % Frecuencia nominal
    f_nominal = 60;
    % Corriente de línea promedio (A)
    I_L = (I_A + I_B + I_C)/3;
    % Voltaje de línea promedio (V)
    V_L = (V_AB + V_BC + V_CA)/3;
    
    % Cálculo de la resistencia del rotor
    % Cálculo del ángulo de impedancia theta (grados)
    theta = acos(FP);
    % Cálculo de la magnitud de la impedancia total del circuito
    Z_RB = V_L / (sqrt(3) * I_L);
    % Cálculo de R_RB
    R_RB = Z_RB * cos(theta);
    % Cálculo de la resistencia del rotor
    R_2 = R_RB - R_1;
    
    % Cálculo de las reactancias del estator y del rotor
    % Cálculo de X'RB
    X_tic_RB = Z_RB * sin(theta);
    % Cálculo de XRB
    X_RB = (f_nominal)/(f_prueba) * X_tic_RB;
    % Cálculo de las reactancias
    X_1 = 0.5 * X_RB;
    X_2 = 0.5 * X_RB;
end

