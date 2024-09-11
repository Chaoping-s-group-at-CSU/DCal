function impurity
% supercell size
global m n p impurity Ele 
atom_perfect = m*n*p; 
atom = atom_perfect-1;%get atoms
% get coordinate information with different supercell
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
