function [ airfoil_data ] = load_airfoil_data( filename )
%LOAD_AIRFOIL_DATA loads airfoil data from filename (str) into struct
%   Detailed explanation goes here
    fileID = fopen(filename,'r');
    block = 1;
    data_set = 1;
    line = textscan(fileID, '%s', 1, 'Delimiter', '\n'); % reads block header
    fprintf(1,'%s\n',line{1}{1})
    fprintf(1,'block number %d\n',block)
    line = textscan(fileID, '%s', 1, 'Delimiter', '\n'); % reads first data group
    line = textscan(fileID, '%d', 1, 'Delimiter', '\n');
    data_set = line{1};
    fprintf(1,'dataset = %d\n', data_set)
    while (~feof(fileID) && block < 4)
        flag = 0;
        while flag == 0
            line = textscan(fileID, '%d %d', 1, 'Delimiter', '\n');
            disp(line);
            if isempty(line(1))
                if findstr(line, 'does not exist')
                    %continues
                elseif findstr(line, 'Data')
                    line = textscan(fileID, '%d', 1, 'Delimiter', '\n');
                    data_set = line{1};
                    fprintf(1,'dataset = %d\n', data_set)
                    flag = 1;
                else findstr(line, 'Found')
                    line = textscan(fileID, '%s', 1, 'Delimiter', '\n'); % reads block header
                    fprintf(1,line{1}{1})
                    block = block + 1;
                    fprintf(1,'block number %d',block)
                    flag = 1;
                end
            else
                point = [line{1}, line{2}];
                % save point in apropiate structure
                fprintf(1,'%d %d \n',point(1),point(2));
            end
        end
    end
    % http://www.mathworks.com/help/matlab/examples/reading-arbitrary-format-text-files-with-textscan.html

end

