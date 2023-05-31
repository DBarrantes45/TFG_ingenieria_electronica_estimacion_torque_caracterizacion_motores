% -------------------------------------------------------------------------
% PRUEBA DE AJUSTE DEL ESTIMADOR DE TORQUE
%
% Este script prueba la función estimadora de torque analizando diferentes
% motores y sus características de torque a diferentes velocidades. Genera
% un gráfico de torque versus velocidad e identifica puntos clave como el
% torque máximo, torque de arranque, torque a plena carga y torque mínimo
% (si corresponde).
%
% El script utiliza la función "estimador_torque_ajuste" para estimar el
% torque para cada combinación de motor y velocidad.
%
% Escrito por Douglas Barrantes Alfaro
% Fecha: mayo, 2023
% -------------------------------------------------------------------------

function [] = Prueba_estimador_torque_ajuste()
    clear;

    % Crea un arreglo con valores de entrada
    valores_entrada = 0:1:1800;
    limite_superior = max(valores_entrada);

    % Crea un arreglo de ceros del mismo tamaño que valores_entrada
    resultados = zeros(1, length(valores_entrada));

    % Lista de motores para analizar
    motores = [1, 2];

    % Crear figura
    figure;
    title('Torque vs Velocidad');
    xlabel('Velocidad [rpm]');
    ylabel('Torque [Nm]');
    hold on;

    for Motor_por_analizar = motores
        % Recorre cada elemento del arreglo valores_entrada
        for i = 1:length(valores_entrada)
            % Llamada a la función estimador_torque con cada valor de entrada
            resultados(i) = estimador_torque_ajuste(Motor_por_analizar, valores_entrada(i));
        end

        % Para el torque a plena carga
        torque_plena_carga = [2.116, 1.081];
        torque_plena_carga = torque_plena_carga(Motor_por_analizar);
        diferencias = abs(resultados - torque_plena_carga);

        [~, ~] = min(diferencias);
        valor_plena_carga = [1770, 1765];
        valor_plena_carga = valor_plena_carga(Motor_por_analizar);

        % Graficar resultados
        plot(valores_entrada, resultados);

        % encontrar el valor máximo en el arreglo de resultados
        [max_result, max_index] = max(resultados);

        % encontrar el valor correspondiente en el arreglo de valores de entrada
        max_value = valores_entrada(max_index);

        % graficar el punto máximo con un marcador
        p1 = scatter(max_value, max_result, 'r*');
        p2 = scatter(0, resultados(valores_entrada == 0), 'm*');
        p3 = scatter(valor_plena_carga, torque_plena_carga, 'b*');

        % agregar una etiqueta con las coordenadas del punto
        text(max_value + 30, max_result, ['(' num2str(max_value) ',' num2str(max_result) ')'], 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');
        text(0 + 30, resultados(valores_entrada == 0), ['(0,' num2str(resultados(valores_entrada == 0)) ')'], 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');
        text(valor_plena_carga + 30, torque_plena_carga, ['(' num2str(valor_plena_carga) ',' num2str(torque_plena_carga) ')'], 'HorizontalAlignment', 'right', 'VerticalAlignment', 'top');

        % Si el límite superior es mayor que 1800, buscar y marcar el torque mínimo
        if limite_superior > 1800
            [min_result, min_index] = min(resultados(1801:end));
            min_value = valores_entrada(min_index + 1800);
            p4 = scatter(min_value, min_result, 'g*');
            text(min_value + 30, min_result, ['(' num2str(min_value) ',' num2str(min_result) ')'], 'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom');
        end
    end

    if limite_superior > 1800
        legend('Motor 1', 'Motor 2', 'Torque Máximo', 'Torque de Arranque', 'Torque a plena carga', 'Torque Mínimo', 'Location', 'southwest');
    else
        legend('Motor 1', 'Motor 2', 'Torque Máximo', 'Torque de Arranque', 'Torque a plena carga', 'Location', 'southwest');
    end
    hold off;
end
