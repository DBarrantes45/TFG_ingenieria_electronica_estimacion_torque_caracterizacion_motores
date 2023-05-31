% -------------------------------------------------------------------------
% ESTIMADOR DE TORQUE PARA LABVIEW
% Esta función estima el torque de un motor de inducción basándose en las
% mediciones en tiempo real de velocidad y voltaje. Los valores obtenidos
% son especialmente útiles para implementar en entornos de control en
% tiempo real como LabVIEW.
%
% Escrito por Douglas Barrantes Alfaro
% Fecha: mayo,2023
% -------------------------------------------------------------------------

function [torque] = estimador_torque_labview(Motor_por_analizar, n_motor, V_phi)

    % ---> SE EXTRAEN LAS VARIABLES NECESARIAS

    %[R_estator, R_rotor, X_estator, X_rotor, X_magnetizacion, Resistencia_nucleo, Perdidas_nucleo, Perdidas_friccion, error_potencia] = caracterizacion_motores();

    % ---> SE DECLARAN VARIABLES
    % Resistencia del núcleo
    Resistencia_nucleo = [3851.4647, 8637.8077];
    R_C = Resistencia_nucleo(Motor_por_analizar);
    % Perdidas del núcleo (W)
    Perdidas_nucleo = [32.11, 14.21];
    P_nucleo = Perdidas_nucleo(Motor_por_analizar);
    % Perdidas por fricción y rozamiento (W)
    Perdidas_friccion = [6.682, 4.175];
    P_FyW = Perdidas_friccion(Motor_por_analizar);
    % Reactancia de magnetización
    X_magnetizacion = [180.378, 280.88];
    X_M = X_magnetizacion(Motor_por_analizar);
    % Resistencia del estator
    R_estator = [10.0646, 23.7769];
    R_1 = R_estator(Motor_por_analizar);
    % Inductancia del estator
    X_estator = [5.8732, 14.4471];
    X_1 = X_estator(Motor_por_analizar);
    % Breakdown Power
    B_P = [2.52, 2.27];
    B_P = B_P(Motor_por_analizar);
    % Resistencia del rotor
    R_rotor = [2.0061, 4.8114];
    R_2 = R_rotor(Motor_por_analizar);
    % Inductancia del rotor
    X_rotor = [5.8732, 14.4471];
    X_2 = X_rotor(Motor_por_analizar);
    % Perdidas iniciales
    Perdidas_iniciales = [0, 0];

    % Velocidad de sincronía (RPM)
    n_sincronia = 1800;
    % Velocidad de sincronía (rad/s)
    w_sincronia = (n_sincronia * 2 * pi) / 60;
    % Velocidad del motor (rad/s)
    w_motor = (n_motor * 2 * pi) / 60;
    % Deslizamiento
    s = (w_sincronia - w_motor) / w_sincronia;

    % ---> PARA EL CÁLCULO DEL VOLTAJE DE THEVENIN
    V_TH = V_phi * (X_M * R_C) / sqrt((R_C * R_1 - X_M * X_1)^2 + (X_M * R_C + X_M * R_1 + X_1 * R_C)^2);

    % ---> PARA EL CÁLCULO DE LA IMPEDANCIA DE THEVENIN
    % Resistencia de Thevenin
    R_TH = (X_M * R_C * R_1 * (-R_C * R_1 + X_M * X_1 + X_M * R_C + X_M * R_1 + R_1 * R_C)) / ((R_C * R_1 - X_M * X_1)^2 + (X_M * R_C + X_M * R_1 + X_1 * R_C)^2);
    % Reactancia de Thevenin
    X_TH = (X_M * R_C * R_1 * (R_C * R_1 - X_M * X_1 + X_M * R_C + X_M * R_1 + R_1 * R_C)) / ((R_C * R_1 - X_M * X_1)^2 + (X_M * R_C + X_M * R_1 + X_1 * R_C)^2);

    % ---> PARA EL CÁLCULO DE LA CORRIENTE I_2
    I_2 = V_TH / sqrt((R_TH + R_2 / s)^2 + (X_TH + X_2)^2);

    % ---> PARA EL CÁLCULO DE LA POTENCIA DEL ENTREHIERRO
    P_AG = 3 / B_P * I_2^2 * R_2 / s;

    % ---> PARA EL CÁLCULO DEL TORQUE INDUCIDO
    T_ind = P_AG / w_sincronia;

    % ---> PARA EL CÁLCULO DEL TORQUE EN LA CARGA
    % Perdidas rotacionales
    P_rot = P_FyW;
    % Perdidas de torque
    T_perdidas = (P_rot * (1 - s)) / w_motor;
    % Torque en la carga (N*m)
    if T_perdidas >= Perdidas_iniciales(Motor_por_analizar)
        T_carga = T_ind - T_perdidas;
    else
        T_carga = T_ind - Perdidas_iniciales(Motor_por_analizar);
    end

    torque = T_carga;

end
