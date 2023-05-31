% -------------------------------------------------------------------------
% FUNCIÓN DE CARACTERIZACIÓN DE MOTORES
%
% Esta función calcula los principales parámetros de los motores utilizando
% diferentes pruebas. Primero, calcula las resistencias del estator para ambos
% motores y luego las reactancias del estator y del rotor, así como la resistencia
% del rotor. Finalmente, la función calcula la reactancia de magnetización, el error
% de potencia y la resistencia del núcleo. Los resultados se resumen en una tabla.
%
% Salidas:
%   - R_1: Resistencia del estator para ambos motores (Ohmios)
%   - R_2: Resistencia del rotor para ambos motores (Ohmios)
%   - X_1: Reactancia del estator para ambos motores (Ohmios)
%   - X_2: Reactancia del rotor para ambos motores (Ohmios)
%   - X_M: Reactancia de magnetización para ambos motores (Ohmios)
%   - R_nucleo: Resistencia del núcleo para ambos motores (Ohmios)
%   - Perdidas_nucleo: Pérdidas en el núcleo para ambos motores (W)
%   - Perdidas_friccion: Pérdidas por fricción para ambos motores (W)
%   - error_potencia: Error de potencia para ambos motores
%
% Escrito por Douglas Barrantes Alfaro
% Fecha: Mayo, 2023
% -------------------------------------------------------------------------

function [R_1, R_2, X_1, X_2, X_M, R_nucleo, Perdidas_nucleo, Perdidas_friccion, error_potencia] = caracterizacion_motores()
    clc
    % Calcula las resistencias del estator para ambos motores
    Resistencias_estator = prueba_dc();

    % Define las corrientes y voltajes de línea (Prueba de Rotor Bloqueado)
    I_linea_A = [1.850, 1.077];
    I_linea_B = [1.876666667, 1.113333333];
    I_linea_C = [1.87, 1.13];
    Voltaje_AB = [54.07, 77.63];
    Voltaje_BC = [55.10, 78.53];
    Voltaje_CA = [54.10, 77.60];
    Factor_Potencia = [0.716666667, 0.703333333]; % Factor de potencia

    % Calcula las reactancias del estator y del rotor, y la resistencia del rotor
    for i = 1:length(Resistencias_estator)
        [R_2(i), X_1(i), X_2(i)] = prueba_rotor_bloqueado(Resistencias_estator(i), I_linea_A(i), I_linea_B(i), I_linea_C(i), Voltaje_AB(i), Voltaje_BC(i), Voltaje_CA(i), Factor_Potencia(i));
    end

    % Define las corrientes, voltajes, y potencia de entrada (Prueba de Vacío)
    I_linea_A = [1.10, 0.70];
    I_linea_B = [1.12, 0.72];
    I_linea_C = [1.15, 0.72];
    Voltaje_AB = [209.3333333, 211];
    Voltaje_BC = [209.6666667, 211];
    Voltaje_CA = [208.6666667, 210];
    P_in = [65, 49]; % Potencia de entrada
    
    % Define otras variables necesarias
    Reactancia_estator = X_1; % Reactancia del estator
    Perdidas_nucleo = [32.11, 14.21]; % Pérdidas del núcleo (W)
    Perdidas_friccion = [6.682, 4.175]; % Pérdidas por fricción y rozamiento (W)

    % Calcula la reactancia de magnetización, el error de potencia y la resistencia del núcleo
    for i = 1:length(Resistencias_estator)
        [X_M(i), error_potencia(i), R_nucleo(i)] = prueba_vacio(I_linea_A(i), I_linea_B(i), I_linea_C(i), Voltaje_AB(i), Voltaje_BC(i), Voltaje_CA(i), P_in(i), Reactancia_estator(i), Resistencias_estator(i), Perdidas_nucleo(i), Perdidas_friccion(i), Factor_Potencia(i));
    end

    % Define R_1 y X_1 como las resistencias y reactancias del estator respectivamente
    R_1 = Resistencias_estator;
    X_1 = Reactancia_estator;

    % Calcula las inductancias
    L_1 = X_1/(2*pi*60);
    L_2 = X_2/(2*pi*60);
    L_M = X_M/(2*pi*60);

    % Prepara la tabla de resumen con los resultados
    valores_1 = [R_1(1), R_2(1), X_1(1), X_2(1), X_M(1), L_1(1), L_2(1), L_M(1), R_nucleo(1), Perdidas_nucleo(1), Perdidas_friccion(1), error_potencia(1)];
    valores_2 = [R_1(2), R_2(2), X_1(2), X_2(2), X_M(2), L_1(2), L_2(2), L_M(2), R_nucleo(2), Perdidas_nucleo(2), Perdidas_friccion(2), error_potencia(2)];
    nombres_variables = {'R_1', 'R_2', 'X_1', 'X_2', 'X_M', 'L_1', 'L_2', 'L_M', 'R_nucleo', 'Perdidas_nucleo', 'Perdidas_friccion', 'error_potencia'};
    tabla_resumen = cell(10,3);
    tabla_resumen(1,:) = {'Variable','Motor 1','Motor 2'};
    
    for j = 1:2
        for i = 1:9
            tabla_resumen{i+1,1} = nombres_variables{i};
            tabla_resumen{i+1,2} = num2str((valores_1(i)));
            tabla_resumen{i+1,3} = num2str((valores_2(i)));
        end
    end
    
    % Muestra los parámetros en la consola
    disp(tabla_resumen);

    % Descomente la siguiente línea para crear una tabla en la interfaz de usuario
    %tabla = uitable('Data', tabla_resumen, 'ColumnName', {'Variable', 'Motor 1', 'Motor 2'}, 'ColumnWidth', {150, 100, 100});
    %set(tabla, 'ColumnFormat', {'char', 'numeric', 'numeric'});
    %set(tabla, 'ColumnEditable', [false true true]);
end
