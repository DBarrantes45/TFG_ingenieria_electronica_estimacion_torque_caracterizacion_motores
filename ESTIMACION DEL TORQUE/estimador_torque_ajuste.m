% -------------------------------------------------------------------------
% ESTIMADOR DE TORQUE PARA MOTOR DE INDUCCIÓN
%
% Esta función estima el torque de un motor de inducción en base a las
% características del motor proporcionadas y la velocidad del motor. 
% Calcula el torque considerando factores como la resistencia del núcleo,
% las pérdidas, la reactancia y el deslizamiento. Además, incluye las 
% variables de ajuste BDT y LRT para controlar el pico máximo de torque y 
% el torque de arranque a medida que aumenta la velocidad del motor.
%
% Entradas:
%   - Motor_to_analyze: Identificador del motor (1 o 2)
%   - n_motor: Velocidad del motor en RPM
%
% Salida:
%   - torque: Torque estimado en Nm
%
% Escrito por Douglas Barrantes Alfaro
% Fecha: mayo, 2023
% -------------------------------------------------------------------------

function [torque] = estimador_torque_ajuste(Motor_to_analyze, n_motor)
    clc;

    % Extraer las variables necesarias
    [R_estator, R_rotor, X_estator, X_rotor, X_magnetizacion, Resistencia_nucleo, Perdidas_nucleo, Perdidas_friccion, error_potencia] = caracterizacion_motores();

    % Declarar variables
    R_C = Resistencia_nucleo(Motor_to_analyze); % Resistencia del núcleo
    P_nucleo = Perdidas_nucleo(Motor_to_analyze); % Pérdidas del núcleo (W)
    P_friccion = Perdidas_friccion(Motor_to_analyze); % Pérdidas por fricción y rozamiento (W)
    X_M = X_magnetizacion(Motor_to_analyze); % Reactancia de magnetización
    R_1 = R_estator(Motor_to_analyze); % Resistencia del estator
    X_1 = X_estator(Motor_to_analyze); % Inductancia del estator
    BDT = [2.52, 2.2327]; % Torque de ruptura (Breakdown torque)
    BDT = BDT(Motor_to_analyze);
    LRT = [0.8196, 0.6499]; % Torque de arranque (Locked rotor torque)
    LRT = LRT(Motor_to_analyze);
    R_2 = R_rotor(Motor_to_analyze); % Resistencia del rotor
    X_2 = X_rotor(Motor_to_analyze); % Inductancia del rotor
    Perdidas_iniciales = [0, 0]; % Pérdidas iniciales
    n_sincronia = 1800; % Velocidad de sincronía (RPM)
    V_phi = 230; % Voltaje de línea a plena carga
    w_sincronia = (n_sincronia*2*pi)/(60); % Velocidad de sincronía (rad/s)
    w_motor = (n_motor*2*pi)/(60); % Velocidad del motor (rad/s)
    s = (w_sincronia - w_motor)/(w_sincronia); % Deslizamiento

    % Coeficiente de ajuste
    if n_motor < 1600
        alpha = ((BDT - LRT)/(1600)) * n_motor + LRT;
    elseif n_motor >= 1600
        alpha = BDT;
    end

    % Impedancia del rotor
    Z_2 = R_2/s + 1i*X_2;

    % Cálculo del voltaje de Thevenin
    V_TH = V_phi * (X_M * R_C) / sqrt((R_C * R_1 - X_M * X_1)^2 + (X_M * R_C + X_M * R_1 + X_1 * R_C)^2);

    % Cálculo de la impedancia de Thevenin
    R_TH = (X_M * R_C * R_1 * (-R_C * R_1 + X_M * X_1 + X_M * R_C + X_M * R_1 + R_1 * R_C)) / ((R_C * R_1 - X_M * X_1)^2 + (X_M * R_C + X_M * R_1 + X_1 * R_C)^2);
    X_TH = (X_M * R_C * R_1 * (R_C * R_1 - X_M * X_1 + X_M * R_C + X_M * R_1 + R_1 * R_C)) / ((R_C * R_1 - X_M * X_1)^2 + (X_M * R_C + X_M * R_1 + X_1 * R_C)^2);
    Z_TH = R_TH + 1i*X_TH;

    % Cálculo de la corriente I_2
    I_2 = V_TH / sqrt((R_TH + R_2/s)^2 + (X_TH + X_2)^2);

    % Cálculo de la potencia del entrehierro
    P_AG = 3/alpha * (I_2)^2 * (R_2)/(s);

    % Cálculo del torque inducido
    T_ind = (P_AG)/(w_sincronia);

    % Cálculo del torque en la carga
    % Pérdidas rotacionales
    P_rot = P_friccion;
    % Pérdidas de torque
    T_perdidas = ((P_rot)*(1 - s))/(w_motor);

    % Torque en la carga (N*m)
    if T_perdidas >= Perdidas_iniciales(Motor_to_analyze)
        T_carga = T_ind - T_perdidas;
    else
        T_carga = T_ind - Perdidas_iniciales(Motor_to_analyze);
    end

    torque = T_carga;
end
