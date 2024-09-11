function w0_self
global m n p
% supercell size
atom_perfect = m*n*p*4;
atom = atom_perfect-1; %get atoms
% get coordinate information with different supercell
axes_init_x = 0.5;
axes_init_y = 0.5;
axes_init_z = 0;
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
modify_poscar('POSCAR', atom, [axes_x, axes_y, axes_z]);
fclose ('all');
end


function modify_poscar(poscar_file, atom_count, target_coordinates, tolerance)
    % Default tolerance value if not provided
    if nargin < 4
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

    % Replace the 7th line with the new atom count
    lines{7} = num2str(atom_count);

    % Find and delete the line containing the target coordinates
    target_line_index = [];
    for i = 9:length(lines) % Start checking from the 8th line
        coords = str2num(lines{i}); %#ok<ST2NM>
        if isempty(coords)
            continue;
        end
        if norm(coords - target_coordinates) < tolerance
            target_line_index = i;
            break;
        end
    end

    if ~isempty(target_line_index)
        lines(target_line_index) = []; % Delete the line
    else
        warning('No matching coordinates found.');
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
