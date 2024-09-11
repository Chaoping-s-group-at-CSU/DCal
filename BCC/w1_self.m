function w1_self
% supercell size
global m n p
atom_perfect = m*n*p;
atom = atom_perfect-1; %get atoms
% get coordinate information with different supercell
axes_init_x = 1;
axes_init_y = 1;
axes_init_z = 1;
axes_x = axes_init_x/m;
axes_y = axes_init_y/n;
axes_z = axes_init_z/p;
axes_init_x1 = 2;
axes_init_y1 = 1;
axes_init_z1 = 1;
axes_x1 = axes_init_x1/m;
axes_y1 = axes_init_y1/n;
axes_z1 = axes_init_z1/p;


files = dir('POSCAR');
if ~isempty(files)
    % If there are files that start with "POSCAR", delete them
    for i = 1:length(files)
        delete(files(i).name);
    end
else
end
copyfile ('POSCAR0','POSCAR');
modify_poscar('POSCAR', atom,[axes_x1, axes_y1, axes_z1],[axes_x, axes_y, axes_z]); %replace 1 to 0
fclose ('all');
end


function modify_poscar(poscar_file, atom_count, target_coords, new_coords, tolerance)
    % Default tolerance value if not provided
    if nargin < 5
        tolerance = 1e-10;
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
    
    % Replace the 7th line with the new atom count
    lines{7} = num2str(atom_count);
    
    % Initialize a variable to keep track of whether the target line is found
    target_line_index = [];
    
    % Create a new cell array for lines to be written back
    new_lines = {};
    
    for i = 1:length(lines)
        if i > 8 % Coordinates typically start from line 8
            coords = str2num(lines{i}); %#ok<ST2NM>
            if ~isempty(coords)
                if norm(coords - target_coords) < tolerance
                    target_line_index = i;
                    lines{i} = sprintf('%.16f %.16f %.16f', new_coords(1), new_coords(2), new_coords(3)); % Replace with new coordinates
                elseif norm(coords - new_coords) < tolerance
                    continue; % Skip lines with the new coordinates
                end
            end
        end
        new_lines{end+1} = lines{i}; %#ok<AGROW>
    end

    if isempty(target_line_index)
        warning('No line with the target coordinates found.');
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
