% -------------------------------------------------------------------------
% RELACIONES DE POTENCIA
%
% Este script se utiliza para comprobar la validez del circuito equivalente desarrollado
% mediante relaciones de potencia, contrastando la potencia estimada con los datos del fabricante,
% porque se conoce el par motor a plena carga y la velocidad a plena carga.
%
% Escrito por Douglas Barrantes Alfaro
% Fecha: Mayo 2023
% -------------------------------------------------------------------------

function [] = relaciones_de_potencia()
    clc
    
    % Datos
    Resistencia_nucleo = [3851.4647, 8637.8077];
    Perdidas_nucleo = [32.11, 14.21];
    Perdidas_friccion = [6.682, 4.175];
    X_magnetizacion = [180.378, 280.88];
    R_estator = [10.0646, 23.7769];
    X_estator = [5.8732, 14.4471];
    R_rotor = [2.0061, 4.8114];
    X_rotor = [5.8732, 14.4471];
    Corriente_linea = [0.912, 0.5437];
    par_motor_plena_carga = [2.1, 1];
    velocidad_plena_carga = [1722, 1722];
    V_phi = 220;

    % Preasignación de matrices de resultados
    resultados = zeros(2, 3);

    % Bucle para analizar ambos motores
    for Motor_a_analizar = 1:2
        % Extraer datos del motor
        R_C = Resistencia_nucleo(Motor_a_analizar);
        P_nucleo = Perdidas_nucleo(Motor_a_analizar);
        P_FyW = Perdidas_friccion(Motor_a_analizar);
        X_M = X_magnetizacion(Motor_a_analizar);
        R_1 = R_estator(Motor_a_analizar);
        X_1 = X_estator(Motor_a_analizar);
        R_2 = R_rotor(Motor_a_analizar);
        X_2 = X_rotor(Motor_a_analizar);
        I_phi = Corriente_linea(Motor_a_analizar);
        T_PC = par_motor_plena_carga(Motor_a_analizar);
        V_PC = velocidad_plena_carga(Motor_a_analizar);
        V_PC_rads = (V_PC * 2 * pi)/60; % Convertir a radianes

        % Calcular potencias
        PO_esperada = T_PC * V_PC_rads;
        s = (1800 - V_PC)/(1800);
        Z_2_techo = R_2/s + 1i*X_2;
        Z_1_techo = R_1 + 1i*X_1;
        Z_e_techo = (1/R_C + 1/(1i*X_M) + 1/(Z_2_techo))^(-1);
        Z_in = Z_1_techo + Z_e_techo;
        Z_in_angulo = deg2rad(angle(Z_in));
        I_1 = V_phi/Z_in;
        I_1_magnitud = abs(I_1);
        P_in = 3 * V_phi * I_phi * cos(Z_in_angulo);
        P_SCL = 3 * I_1_magnitud * R_1;
        E_1 = V_phi - I_1 * Z_1_techo;
        I_C = E_1 / R_C;
        I_M = E_1 / (1i * X_M);
        I_phi = I_C + I_M;
        I_2 = I_1 - I_phi;
        P_nucleo = 3 * abs(I_C)^2 * R_C;
        P_AG = P_in - P_SCL - P_nucleo;
        P_RCL = 3 * abs(I_2)^2 * R_2;
        P_d = P_AG - P_RCL;
        PO_estimada = P_d - P_FyW;

        % Calcular el porcentaje de error
        error = (PO_estimada - PO_esperada) / (PO_esperada) * 100;

        % Almacenar los resultados en la matriz
        resultados(Motor_a_analizar, :) = [PO_esperada, PO_estimada, error];
    end

    % Mostrar resultados en forma de tabla
    disp('Motor | Potencia esperada | Potencia estimada | % Error')
    for i = 1:size(resultados, 1)
        fprintf('  %d   |      %.2f W      |      %.2f W      |  %.2f %%\n', i, resultados(i, 1), resultados(i, 2), resultados(i, 3));
    end

end

