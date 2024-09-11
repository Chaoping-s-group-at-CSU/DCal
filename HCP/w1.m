function w1
% supercell size
global m n p impurity Ele 
atom_perfect = m*n*p*2;
atom = atom_perfect-2; %get atoms
% get coordinate information with different supercell
axes_init_x = 1.3333333333;
axes_init_y = 0.6666666666;
axes_init_z = 0.5;
axes_x = axes_init_x/m;
axes_y = axes_init_y/n;
axes_z = axes_init_z/p;
files = dir('POSCAR');
if ~isempty(files)
    % If there are files that start with "POSCAR", delete them
    for i = 1:length(files)
        delete(files(i).name);
    end
else
end
copyfile ('POSCAR0','POSCAR');
update_poscar('POSCAR', Ele, impurity, atom);
modify_poscar('POSCAR', [axes_x, axes_y, axes_z]);
fclose ('all');
end

function update_poscar(poscar_file, element_Z, element_X, y_value)
    % Validate y_value
    if mod(y_value, 1) ~= 0
        error('y_value must be an integer.');
    end

    % Read the POSCAR file content
    fid = fopen(poscar_file, 'r');
    if fid == -1
        error('Cannot open file: %s', poscar_file);
    end
    lines = {};
    while ~feof(fid)
        lines{end+1} = fgetl(fid); %#ok<AGROW>
    end
    fclose(fid);

    % Replace the 6th line with 'Z X' where Z and X are the input elements
    if length(lines) >= 6
        lines{6} = sprintf('%s %s', element_Z, element_X);
    else
        error('The POSCAR file does not have enough lines.');
    end

    % Replace the 7th line with 'y 1' where y is the input integer value
    if length(lines) >= 7
        lines{7} = sprintf('%d 1', y_value);
    else
        error('The POSCAR file does not have enough lines.');
    end

    % Write the modified content back to the file
    fid = fopen(poscar_file, 'w');
    if fid == -1
        error('Cannot write to file: %s', poscar_file);
    end
    for i = 1:length(lines)
        fprintf(fid, '%s\n', lines{i});
    end
    fclose(fid);
end


function modify_poscar(poscar_file, coord_to_delete, tolerance)
global m n p
    % Default tolerance value if not provided
    if nargin < 3
        tolerance = 1e-4;
    end

    % Read the POSCAR file content
    fid = fopen(poscar_file, 'r');
    if fid == -1
        error('Cannot open file: %s', poscar_file);
    end
    lines = {};
    while ~feof(fid)
        lines{end+1} = fgetl(fid); %#ok<AGROW>
    end
    fclose(fid);

    % Initialize variables for new lines
    new_lines = {};
    zero_coords_line = [];
    
    impurity_a = 0.333333334/m;
    impurity_b = 0.666666667/n;
    impurity_c = 0.5/p;
    % Process each line
    for i = 1:length(lines)
        if i > 8 % Coordinates typically start from line 8
            coords = str2num(lines{i}); %#ok<ST2NM>
            if ~isempty(coords)
                if norm(coords - [impurity_a, impurity_b, impurity_c]) < tolerance
                    zero_coords_line = lines{i}; % Save the zero coordinate line
                    continue; % Skip the zero coordinate line in the output
                elseif norm(coords - coord_to_delete) < tolerance
                    % Skip lines with the coordinates to be deleted
                    continue;
                end
            end
        end
        new_lines{end+1} = lines{i}; %#ok<AGROW>
    end
    
    % Add the zero coordinates line at the end
    if ~isempty(zero_coords_line)
        new_lines{end+1} = zero_coords_line;
    else
        warning('No line with coordinates [0, 0, 0] found.');
    end
    
    % Write the modified content back to the file
    fid = fopen(poscar_file, 'w');
    if fid == -1
        error('Cannot write to file: %s', poscar_file);
    end
    for i = 1:length(new_lines)
        fprintf(fid, '%s\n', new_lines{i});
    end
    fclose(fid);
end
