function [ airfoil_data ] = load_airfoil_data( filename )
%LOAD_AIRFOIL_DATA loads airfoil data from filename (str) into struct
%   Detailed explanation goes here
    fileID = fopen(filename,'r');
    while (~feof(fileID))
        line = textscan(fileID, '%s', 1, 'Delimiter', '\n');
        % Esto es para leer los datos
        line = textscan(fileID, '%f %f', 1, 'Delimiter', '\n');
        % http://www.mathworks.com/help/matlab/examples/reading-arbitrary-format-text-files-with-textscan.html
    end

end

