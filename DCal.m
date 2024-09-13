function DCal()
% Create figure window
f = figure('Position', [100, 100, 690, 467], 'Name', 'DCal.app', 'NumberTitle', 'off');

% Create TabGroup as a container for tabs (since Octave doesn't have a direct equivalent)
% Use uipanel to simulate tabs
tabGroup = uipanel('Parent', f, 'Position', [0, 0, 1, 1]);

% Create DiffusioncoefficientcalculationTab
tabPanel = uipanel('Parent', tabGroup, 'Position', [0, 0, 1, 1]);

% Create first axes (D_draw)
ax1 = axes('Parent', tabPanel, 'Position', [0.096, 0.1, 0.45, 0.55]);
title(ax1, 'Tracer diffusion');
xlabel(ax1, '1000/T (K^{-1})');
ylabel(ax1, 'D (m^2/s)');
set(ax1, 'YScale', 'log');

% Create second axes (D_inter_draw)
ax2 = axes('Parent', tabPanel, 'Position', [0.65, 0.08, 0.32, 0.37]);
title(ax2, 'Interdiffusion');
xlabel(ax2, 'X Conc.');
ylabel(ax2, 'D (m^2/s)');

% Create UI controls with callback functions

% Matrix element
uicontrol('Style', 'text', 'Parent', tabPanel, 'Position', [255, 420, 130, 30], ...
    'String', 'Matrix element', 'FontSize', 12);
matrixElementField = uicontrol('Style', 'edit', 'Parent', tabPanel, 'Position', [384, 420, 50, 27], ...
    'FontSize', 12);

% Crystal structure
uicontrol('Style', 'text', 'Parent', tabPanel, 'Position', [8, 420, 130, 30], ...
    'String', 'Crystal structure', 'FontSize', 12);
crystalStructureMenu = uicontrol('Style', 'popupmenu', 'Parent', tabPanel, 'Position', [139, 420, 75, 27], ...
    'String', {'FCC', 'BCC', 'HCP'}, 'FontSize', 12, 'Tag', 'myPopupMenu');

% Lattice constant
uicontrol('Style', 'text', 'Parent', tabPanel, 'Position', [8, 375, 30, 30], ...
    'String', 'a', 'FontSize', 12);
aField = uicontrol('Style', 'edit', 'Parent', tabPanel, 'Position', [38, 375, 40, 27], ...
    'FontSize', 12');
uicontrol('Style', 'text', 'Parent', tabPanel, 'Position', [85, 375, 30, 30], ...
    'String', 'b', 'FontSize', 12);
bField = uicontrol('Style', 'edit', 'Parent', tabPanel, 'Position', [115, 375, 40, 27], ...
    'FontSize', 12');
uicontrol('Style', 'text', 'Parent', tabPanel, 'Position', [162, 375, 30, 30], ...
    'String', 'c', 'FontSize', 12);
cField = uicontrol('Style', 'edit', 'Parent', tabPanel, 'Position', [192, 375, 40, 27], ...
    'FontSize', 12');

% Supercell
uicontrol('Style', 'text', 'Parent', tabPanel, 'Position', [270, 375, 70, 30], ...
    'String', 'Supercell', 'FontSize', 12);
AField = uicontrol('Style', 'edit', 'Parent', tabPanel, 'Position', [346, 375, 30, 27], ...
    'FontSize', 12');
uicontrol('Style', 'text', 'Parent', tabPanel, 'Position', [377, 375, 20, 30], ...
    'String', '×', 'FontSize', 14);
BField = uicontrol('Style', 'edit', 'Parent', tabPanel, 'Position', [398, 375, 30, 27], ...
    'FontSize', 12');
uicontrol('Style', 'text', 'Parent', tabPanel, 'Position', [429, 375, 20, 30], ...
    'String', '×', 'FontSize', 14);
CField = uicontrol('Style', 'edit', 'Parent', tabPanel, 'Position', [450, 375, 30, 27], ...
    'FontSize', 12');

% Generate initial structure button
uicontrol('Style', 'pushbutton', 'Parent', tabPanel, 'Position', [17, 330, 220, 30], ...
    'String', 'Generate initial structure', 'FontSize', 13, 'Callback', @generateInitialStructureCallback);

% Impurity element
uicontrol('Style', 'text', 'Parent', tabPanel, 'Position', [480, 420, 130, 30], ...
    'String', 'Impurity element', 'FontSize', 12);
impurityElementField = uicontrol('Style', 'edit', 'Parent', tabPanel, 'Position', [614, 420, 50, 27], ...
    'FontSize', 12);

% Generate paths button
uicontrol('Style', 'pushbutton', 'Parent', tabPanel, 'Position', [272, 330, 140, 30], ...
    'String', 'Generate paths', 'FontSize', 12, 'Callback', @generatePathsCallback);

% Path
uicontrol('Style', 'text', 'Parent', tabPanel, 'Position', [514, 375, 50, 30], ...
    'String', 'Path', 'FontSize', 12);
pathField = uicontrol('Style', 'edit', 'Parent', tabPanel, 'Position', [562, 375, 101, 27], ...
    'FontSize', 12);

% Temperature (T) for D
uicontrol('Style', 'text', 'Parent', tabPanel, 'Position', [440, 330, 50, 30], ...
    'String', 'T (K)', 'FontSize', 12);
tempFieldStart = uicontrol('Style', 'edit', 'Parent', tabPanel, 'Position', [490, 330, 35, 27], ...
    'FontSize', 12);
uicontrol('Style', 'text', 'Parent', tabPanel, 'Position', [530, 330, 15, 30], ...
    'String', '——', 'FontSize', 13);
tempFieldEnd = uicontrol('Style', 'edit', 'Parent', tabPanel, 'Position', [552, 330, 35, 27], ...
    'FontSize', 12);
uicontrol('Style', 'pushbutton', 'Parent', tabPanel, 'Position', [600, 330, 62, 30], ...
    'String', 'Get D', 'FontSize', 12, 'Callback', @getDCallback);

% Temperature (T) for D_inter
uicontrol('Style', 'text', 'Parent', tabPanel, 'Position', [440, 240, 50, 30], ...
    'String', 'T (K)', 'FontSize', 12);
tempFieldD_inter = uicontrol('Style', 'edit', 'Parent', tabPanel, 'Position', [490, 240, 35, 27], ...
    'FontSize', 12);
uicontrol('Style', 'pushbutton', 'Parent', tabPanel, 'Position', [550, 240, 110, 30], ...
    'String', 'Get D_inter', 'FontSize', 12, 'Callback', @getD_interCallback);

% X Conc.
uicontrol('Style', 'text', 'Parent', tabPanel, 'Position', [436, 285, 130, 30], ...
    'String', 'X Conc. (at. %)', 'FontSize', 12);
xConcStartField = uicontrol('Style', 'edit', 'Parent', tabPanel, 'Position', [563, 285, 35, 27], ...
    'FontSize', 12);
uicontrol('Style', 'text', 'Parent', tabPanel, 'Position', [603, 285, 15, 30], ...
    'String', '——', 'FontSize', 13);
xConcEndField = uicontrol('Style', 'edit', 'Parent', tabPanel, 'Position', [625, 285, 35, 27], ...
    'FontSize', 12);

% Callback functions
validElements = {'H', 'He', 'Li', 'Be', 'B', 'C', 'N', 'O', 'F', 'Ne', 'Na', 'Mg', 'Al', 'Si', 'P', 'S', 'Cl',...
    'Ar', 'K', 'Ca', 'Sc', 'Ti', 'V', 'Cr', 'Mn', 'Fe', 'Co', 'Ni', 'Cu', 'Zn', 'Ga', 'Ge', 'As', 'Se', 'Br', ...
    'Kr', 'Rb', 'Sr', 'Y', 'Zr', 'Nb', 'Mo', 'Tc', 'Ru', 'Rh', 'Pd', 'Ag', 'Cd', 'In', 'Sn', 'Sb', 'Te', 'I', ...
    'Xe', 'Cs', 'Ba', 'La', 'Ce', 'Pr', 'Nd', 'Pm', 'Sm', 'Eu', 'Gd', 'Tb', 'Dy', 'Ho', 'Er', 'Tm', 'Yb', 'Lu',...
    'Hf', 'Ta', 'W', 'Re', 'Os', 'Ir', 'Pt', 'Au', 'Hg', 'Tl', 'Pb', 'Bi', 'Po', 'At', 'Rn', 'Fr', 'Ra', 'Ac',...
    'Th', 'Pa', 'U', 'Np', 'Pu', 'Am', 'Cm', 'Bk', 'Cf', 'Es', 'Fm', 'Md', 'No', 'Lr', 'Rf', 'Db', 'Sg', 'Bh',...
    'Hs', 'Mt', 'Ds', 'Rg', 'Cn', 'Nh', 'Fl', 'Mc', 'Lv', 'Ts', 'Og','none'};

    function generateInitialStructureCallback(src, eventdata)
        popupHandle = findobj('Tag', 'myPopupMenu');
        popupOptions = get(popupHandle, 'String');
        selectedIndex = get(popupHandle, 'Value');
        if iscell(popupOptions)
            structure = popupOptions{selectedIndex};
        else
            error('Popup menu options are not in cell array format.');
        end
        
        Element = get(findobj('Style', 'edit', 'Position', [384, 420, 50, 27]), 'String');
        % Define valid elements from the periodic table
        
        % Check if input is empty or not a valid element
        if isempty(Element) || ~ismember(Element, validElements)
            % Display an error dialog
            errordlg('Invalid input. Please enter a valid element from the periodic table.', 'Input Error');
            return;
        end
        a = get(findobj('Style', 'edit', 'Position', [38, 375, 40, 27]), 'String');
        a = str2double(a)
        b = get(findobj('Style', 'edit', 'Position', [115, 375, 40, 27]), 'String');
        b = str2double(b);
        c = get(findobj('Style', 'edit', 'Position', [192, 375, 40, 27]), 'String');
        c = str2double(c);
        m = get(findobj('Style', 'edit', 'Position', [346, 375, 30, 27]), 'String');
        m = str2double(m);
        n = get(findobj('Style', 'edit', 'Position', [398, 375, 30, 27]), 'String');
        n = str2double(n);
        p = get(findobj('Style', 'edit', 'Position', [450, 375, 30, 27]), 'String');
        p = str2double(p);
        filename = [structure,'_POSCAR_ORI'];
        if  isnan(a) || isnan(b) || isnan(c) || a == 0 || b == 0 || c == 0
            errordlg('Please enter the right lattice constants!', 'Error');
            return;
        end
        if isnan(m) || isnan(n) || isnan(p) || m == 0 || n == 0 || p == 0 || ...
                mod(m, 1) ~= 0 || mod(n, 1) ~= 0 || mod(p, 1) ~= 0
            errordlg('Please enter the right supercell size! Values must be positive integers.', 'Error');
            return;
        end
        cd (structure)
        files = dir('POSCAR_*');
        if ~isempty(files)
            % If there are files that start with "POSCAR", delete them
            for i = 1:length(files)
                delete(files(i).name);
            end
        end
        POSCAR = fileread(filename);
        POSCAR = strrep(POSCAR, 'Element', Element);
        if strcmp(structure, 'FCC')
            a = num2str(a, '%.16f');
            b = num2str(b, '%.16f');
            c = num2str(c, '%.16f');
            POSCAR = strrep(POSCAR, 'a_ori', a);
            POSCAR = strrep(POSCAR, 'b_ori', b);
            POSCAR = strrep(POSCAR, 'c_ori', c);
            % Generate a file name to save the file
            outputFilename = fullfile('POSCAR_FCC_unit' );
            
            % Save the replacement file
            fid = fopen(outputFilename, 'w');
            fprintf(fid, '%s', POSCAR);
            fclose(fid);
            % change to supercell
            geo1 = import_poscar('POSCAR_FCC_unit');
            array = [m, n, p];
            geo2 = supercell(geo1, array);
            % Generate a file name to save the file
            outputFilename2 = fullfile(['POSCAR_' structure '_' Element ]);
            export_poscar(outputFilename2, geo2);
        elseif strcmp(structure, 'BCC')
            a = num2str(a/2, '%.16f');
            b = num2str(-b/2, '%.16f');
            POSCAR = strrep(POSCAR, 'a_ori', a);
            POSCAR = strrep(POSCAR, 'b_ori', b);
            % Generate a file name to save the file
            outputFilename = fullfile('POSCAR_BCC_unit' );
            
            % Save the replacement file
            fid = fopen(outputFilename, 'w');
            fprintf(fid, '%s', POSCAR);
            fclose(fid);
            % change to supercell
            geo1 = import_poscar('POSCAR_BCC_unit');
            array = [m, n, p]
            geo2 = supercell(geo1, array);
            % Generate a file name to save the file
            outputFilename2 = fullfile(['POSCAR_' structure '_' Element ]);
            export_poscar(outputFilename2, geo2);
            
        else
            a = num2str(a/2, '%.16f');
            h = num2str(b/2*(3^0.5), '%.16f');
            e = num2str(-b/2*(3^0.5), '%.16f');
            c = num2str(c, '%.16f');
            POSCAR = strrep(POSCAR, 'a_ori', a);
            POSCAR = strrep(POSCAR, 'b_ori', h);
            POSCAR = strrep(POSCAR, 'd_ori', e);
            POSCAR = strrep(POSCAR, 'c_ori', c);
            % Generate a file name to save the file
            outputFilename = fullfile('POSCAR_HCP_unit' );
            
            % Save the replacement file
            fid = fopen(outputFilename, 'w');
            fprintf(fid, '%s', POSCAR);
            fclose(fid);
            % change to supercell
            geo1 = import_poscar('POSCAR_HCP_unit');
            array = [m, n, p]
            geo2 = supercell(geo1, array);
            % Generate a file name to save the file
            outputFilename2 = fullfile(['POSCAR_' structure '_' Element ]);
            export_poscar(outputFilename2, geo2);
            
        end
        
        cd ..
        % After the operation succeeds, a message box is displayed to notify the user
        createCustomMessageBox('Run successfully', 'Tips', 12, [300, 300, 300, 150]);
        
        function createCustomMessageBox(message, title, fontSize, position)
            d = dialog('Position', position, 'Name', title);
            
            % Dynamically calculates the position and size of text controls
            txt = uicontrol('Parent', d, 'Style', 'text', ...
                'Position', [20, position(4)-70, position(3)-40, 40], ...
                'String', message, ...
                'FontSize', fontSize);
            
            btn = uicontrol('Parent', d, ...
                'Position', [(position(3)-70)/2, 20, 70, 25], ...
                'String', 'Close', ...
                'Callback', @(src, event) delete(d));
        end
        function closeDialog(d)
            delete(d);
        end
    end




    function generatePathsCallback(src, eventdata)
        global impurity path Ele m n p
        popupHandle = findobj('Tag', 'myPopupMenu');
        popupOptions = get(popupHandle, 'String');
        selectedIndex = get(popupHandle, 'Value');
        if iscell(popupOptions)
            structure = popupOptions{selectedIndex};
        else
            error('Popup menu options are not in cell array format.');
        end
        m = get(findobj('Style', 'edit', 'Position', [346, 375, 30, 27]), 'String');
        m = str2double(m);
        n = get(findobj('Style', 'edit', 'Position', [398, 375, 30, 27]), 'String');
        n = str2double(n);
        p = get(findobj('Style', 'edit', 'Position', [450, 375, 30, 27]), 'String');
        p = str2double(p);
        Element = get(findobj('Style', 'edit', 'Position', [384, 420, 50, 27]), 'String');
        impurity = get(findobj('Style', 'edit', 'Position', [614, 420, 50, 27]), 'String');
        % Ensure Element and impurity are not the same
        if strcmp(Element, impurity)
            errordlg('Element and impurity cannot be the same. Please re-enter.', 'Error');
            return;
        end
        if isempty(Element) || ~ismember(Element, validElements)
            % Display an error dialog
            errordlg('Invalid input. Please enter a valid element from the periodic table.', 'Input Error');
            return;
        end
        if isempty(impurity) || ~ismember(impurity, validElements)
            % Display an error dialog
            errordlg('Invalid input. Please enter a valid element from the periodic table.', 'Input Error');
            return;
        end
        if isnan(m) || isnan(n) || isnan(p) || m == 0 || n == 0 || p == 0 || ...
                mod(m, 1) ~= 0 || mod(n, 1) ~= 0 || mod(p, 1) ~= 0
            errordlg('Please enter the right supercell size! Values must be positive integers.', 'Error');
            return;
        end
        cd (structure);
        if ~exist('POSCAR','file')
            createCustomMessageBox('POSCAR does not exist!', 'Error',12,[300, 300, 300, 150]);
        end
        POSCAR0 = fileread ('POSCAR');
        POSCAR = strsplit(POSCAR0, '\n');
        A = POSCAR (1,6);
        
        % Converts a cell array to a character array
        A_str = cellfun(@num2str, A, 'UniformOutput', false);
        % Concatenate an array of characters into a string
        A = cell2mat(A_str);
        Ele = strrep(A, ' ', '') ;% Delete Spaces in the string
        if ~strcmp(Ele, Element)
            errordlg('The element you entered is different from the element in the POSCAR. Please check!', 'Error');
            cd ..
            return;
        end
        if strcmp(structure, 'FCC')
            diffusion_path_FCC;
        elseif strcmp(structure, 'BCC')
            diffusion_path_BCC;
        else
            diffusion_path_HCP;
        end
        createCustomMessageBox('Run successfully', 'Tips', 12, [300, 300, 300, 150]);
        cd ..
        cd ..
        cd ..
        function createCustomMessageBox(message, title, fontSize, position)
            d = dialog('Position', position, 'Name', title);
            
            % Dynamically calculates the position and size of text controls
            txt = uicontrol('Parent', d, 'Style', 'text', ...
                'Position', [20, position(4)-70, position(3)-40, 40], ...
                'String', message, ...
                'FontSize', fontSize);
            
            btn = uicontrol('Parent', d, ...
                'Position', [(position(3)-70)/2, 20, 70, 25], ...
                'String', 'Close', ...
                'Callback', @(src, event) delete(d));
        end
        function closeDialog(d)
            delete(d);
        end
    end


    function getDCallback(src, eventdata)
        global Element impurity path m n p
        m = get(findobj('Style', 'edit', 'Position', [346, 375, 30, 27]), 'String');
        m = str2double(m);
        n = get(findobj('Style', 'edit', 'Position', [398, 375, 30, 27]), 'String');
        n = str2double(n);
        p = get(findobj('Style', 'edit', 'Position', [450, 375, 30, 27]), 'String');
        p = str2double(p);
        if isnan(m) || isnan(n) || isnan(p) || m == 0 || n == 0 || p == 0 || ...
                mod(m, 1) ~= 0 || mod(n, 1) ~= 0 || mod(p, 1) ~= 0
            errordlg('Please enter the right supercell size! Values must be positive integers.', 'Error');
            return;
        end
        popupHandle = findobj('Tag', 'myPopupMenu');
        popupOptions = get(popupHandle, 'String');
        selectedIndex = get(popupHandle, 'Value');
        if iscell(popupOptions)
            structure = popupOptions{selectedIndex};
        else
            error('Popup menu options are not in cell array format.');
        end
        Element = get(findobj('Style', 'edit', 'Position', [384, 420, 50, 27]), 'String');
        impurity = get(findobj('Style', 'edit', 'Position', [614, 420, 50, 27]), 'String');
        if strcmp(Element, impurity)
            errordlg('Element and impurity cannot be the same. Please re-enter.', 'Error');
            return;
        end
        path = get(findobj('Style', 'edit', 'Position', [562, 375, 101, 27]), 'String');
        if isempty(Element) || ~ismember(Element, validElements)
            % Display an error dialog
            errordlg('Invalid input. Please enter a valid element from the periodic table.', 'Input Error');
            return;
        end
        if isempty(impurity) || ~ismember(impurity, validElements)
            % Display an error dialog
            errordlg('Invalid input. Please enter a valid element from the periodic table.', 'Input Error');
            return;
        end
        if strcmp(impurity, 'none')
            if strcmpi(structure, 'FCC')
                filename_D = 'D_FCC_self.m';
            elseif strcmpi(structure, 'BCC')
                filename_D = 'D_BCC_self.m';
            else
                filename_D = 'D_HCP_self.m';
                f_HCP = 'f_HCP.dat';
            end
            copyfile (filename_D, path);
            if strcmp(structure, 'HCP')
                copyfile (f_HCP,path)
            end
            %copyfile (filename_F, path);
            copyfile ('readFreq.m', path);
            copyfile ('ReadWfactor.m',path);
            cd (path)
            cd ('ori')
            path2 = ['../readFreq.m'];
            copyfile (path2, '.');
            readFreq;
            cd ..
            if strcmp(structure, 'FCC')
                ReadWfactor([0,1]);
                T_init= get(findobj('Style', 'edit', 'Position', [490, 330, 35, 27]), 'String');
                T_init = str2double(T_init);
                T_end= get(findobj('Style', 'edit', 'Position', [552, 330, 35, 27]), 'String');
                T_end = str2double(T_end);
                % Check if the inputs are valid numbers and within range
                if isnan(T_init) || isnan(T_end) || mod(T_init, 10) ~= 0 || T_init < 10 || T_init > 2800 || mod(T_end, 10) ~= 0 || T_end < 10 || T_end > 2800
                    errordlg('Temperature must be a multiple of 10 between 10 and 2800.', 'Error');
                    return;
                end
                D_FCC_self([T_init,T_end]);
                D_results=dlmread('D_self.dat');
                x_data= D_results(:,2);
                yX_data=D_results(:,3);
                xMin = x_data(end);
                xMax = x_data(1);
                yMin = min(yX_data);
                yMax = max(yX_data);
                plot(ax1, x_data, log(yX_data));
                xlim([xMin xMax]);
                ylim([log(yMin) log(yMax)]);
                log_yTicks = linspace(log(yMin), log(yMax), 5);
                yTicks = exp(log_yTicks);
                yTickLabels = arrayfun(@(v) sprintf('%.2e', v), yTicks, 'UniformOutput', false);
                set(ax1, 'YTick', log_yTicks, 'YTickLabel', yTickLabels);
                legend(ax1, 'Self');
                ylabel(ax1, 'D (m^2/s)');
                xlabel(ax1, '1000/T (K^{-1})');
            elseif strcmp(structure, 'BCC')
                ReadWfactor([0,1]);
                T_init= get(findobj('Style', 'edit', 'Position', [490, 330, 35, 27]), 'String');
                T_init = str2double(T_init);
                T_end= get(findobj('Style', 'edit', 'Position', [552, 330, 35, 27]), 'String');
                T_end = str2double(T_end);
                % Check if the inputs are valid numbers and within range
                if isnan(T_init) || isnan(T_end) || mod(T_init, 10) ~= 0 || T_init < 10 || T_init > 2800 || mod(T_end, 10) ~= 0 || T_end < 10 || T_end > 2800
                    errordlg('Temperature must be a multiple of 10 between 10 and 2800.', 'Error');
                    return;
                end
                D_BCC_self([T_init,T_end]);
                D_results=dlmread('D_self.dat');
                x_data= D_results(:,2);
                yX_data=D_results(:,3);
                xMin = x_data(end);
                xMax = x_data(1);
                yMin = min(yX_data);
                yMax = max(yX_data);
                plot(ax1, x_data, log(yX_data));
                xlim([xMin xMax]);
                ylim([log(yMin) log(yMax)]);
                log_yTicks = linspace(log(yMin), log(yMax), 5);
                yTicks = exp(log_yTicks);
                yTickLabels = arrayfun(@(v) sprintf('%.2e', v), yTicks, 'UniformOutput', false);
                set(ax1, 'YTick', log_yTicks, 'YTickLabel', yTickLabels);
                legend(ax1, 'Self');
                ylabel(ax1, 'D (m^2/s)');
                xlabel(ax1, '1000/T (K^{-1})');
            else
                ReadWfactor([0,1]);
                ReadWfactor([0,2]);
                T_init= get(findobj('Style', 'edit', 'Position', [490, 330, 35, 27]), 'String');
                T_init = str2double(T_init);
                T_end= get(findobj('Style', 'edit', 'Position', [552, 330, 35, 27]), 'String');
                T_end = str2double(T_end);
                % Check if the inputs are valid numbers and within range
                if isnan(T_init) || isnan(T_end) || mod(T_init, 10) ~= 0 || T_init < 10 || T_init > 2800 || mod(T_end, 10) ~= 0 || T_end < 10 || T_end > 2800
                    errordlg('Temperature must be a multiple of 10 between 10 and 2800.', 'Error');
                    return;
                end
                D_HCP_self([T_init,T_end]);
                D_results=dlmread('D_self.dat');
                x_data= D_results(:,2);
                y1_data=D_results(:,3);
                y2_data=D_results(:,4);
                xMin = x_data(end);
                xMax = x_data(1);
                yMin = min([y1_data(1),y2_data(1)]);
                yMax = max([y1_data(end),y2_data(end)]);
                plot(ax1, x_data, log(y1_data),x_data,log(y2_data));
                xlim([xMin xMax]);
                ylim([log(yMin) log(yMax)]);
                log_yTicks = linspace(log(yMin), log(yMax), 5);
                yTicks = exp(log_yTicks);
                yTickLabels = arrayfun(@(v) sprintf('%.2e', v), yTicks, 'UniformOutput', false);
                set(ax1, 'YTick', log_yTicks, 'YTickLabel', yTickLabels);
                legend(ax1, 'Self\_Basal','Self\_C');
                ylabel(ax1, 'D (m^2/s)');
                xlabel(ax1, '1000/T (K^{-1})');
            end
        else
            if strcmpi(structure, 'FCC')
                filename_D = 'D_FCC.m';
            elseif strcmpi(structure, 'BCC')
                filename_D = 'D_BCC.m';
            else
                filename_D = 'D_HCP.m';
                f_HCP = 'f_HCP.dat';
            end
            
            copyfile (filename_D, path);
            if strcmp(structure, 'HCP')
                copyfile (f_HCP,path)
            end
            %copyfile (filename_F, path);
            copyfile ('readFreq.m', path);
            copyfile ('ReadWfactor.m',path);
            cd (path)
            filename_main = [Element,'-',impurity];
            cd ..
            cd (Element)
            cd ('ori')
            path2 = ['../../',filename_main,'/readFreq.m'];
            path3 = ['../',filename_main,'/ReadWfactor.m'];
            copyfile (path2, '.');
            readFreq;
            cd ..
            copyfile (path3, '.');
            if strcmp(structure, 'FCC')
                ReadWfactor([0,1]);
                cd ..
                cd (filename_main)
                cd (impurity)
                copyfile ('../readFreq.m','.')
                readFreq
                cd ..
                ReadWfactor([0,1]);
                ReadWfactor([0,2]);
                ReadWfactor([0,3]);
                T_init= get(findobj('Style', 'edit', 'Position', [490, 330, 35, 27]), 'String');
                T_init = str2double(T_init);
                T_end= get(findobj('Style', 'edit', 'Position', [552, 330, 35, 27]), 'String');
                T_end = str2double(T_end);
                % Check if the inputs are valid numbers and within range
                if isnan(T_init) || isnan(T_end) || mod(T_init, 10) ~= 0 || T_init < 10 || T_init > 2800 || mod(T_end, 10) ~= 0 || T_end < 10 || T_end > 2800
                    errordlg('Temperature must be a multiple of 10 between 10 and 2800.', 'Error');
                    return;
                end
                D_FCC([T_init,T_end]);
                D_results=dlmread('D.dat');
                x_data= D_results(:,2);
                yX_data=D_results(:,3);
                ymain_data=D_results(:,4);
                xMin = x_data(end);
                xMax = x_data(1);
                yMin = min([yX_data; ymain_data]);
                yMax = max([yX_data; ymain_data]);
                plot(ax1, x_data, log(yX_data), x_data, log(ymain_data));
                xlim([xMin xMax]);
                ylim([log(yMin) log(yMax)]);
                log_yTicks = linspace(log(yMin), log(yMax), 5);
                yTicks = exp(log_yTicks);
                yTickLabels = arrayfun(@(v) sprintf('%.2e', v), yTicks, 'UniformOutput', false);
                set(ax1, 'YTick', log_yTicks, 'YTickLabel', yTickLabels);
                legend(ax1, 'Impurity', 'Self');
                ylabel(ax1, 'D (m^2/s)');
                xlabel(ax1, '1000/T (K^{-1})');
            elseif strcmp(structure, 'BCC')
                ReadWfactor([0,1]);
                cd ..
                cd (filename_main)
                cd (impurity)
                copyfile ('../readFreq.m','.')
                readFreq
                cd ..
                ReadWfactor([0,2]);
                ReadWfactor([0,3]);
                ReadWfactor([0,4]);
                ReadWfactor([3,5]);
                T_init= get(findobj('Style', 'edit', 'Position', [490, 330, 35, 27]), 'String');
                T_init = str2double(T_init);
                T_end= get(findobj('Style', 'edit', 'Position', [552, 330, 35, 27]), 'String');
                T_end = str2double(T_end);
                % Check if the inputs are valid numbers and within range
                if isnan(T_init) || isnan(T_end) || mod(T_init, 10) ~= 0 || T_init < 10 || T_init > 2800 || mod(T_end, 10) ~= 0 || T_end < 10 || T_end > 2800
                    errordlg('Temperature must be a multiple of 10 between 10 and 2800.', 'Error');
                    return;
                end
                D_BCC([T_init,T_end]);
                D_results=dlmread('D.dat');
                x_data= D_results(:,2);
                yX_data=D_results(:,3);
                ymain_data=D_results(:,4);
                xMin = x_data(end);
                xMax = x_data(1);
                yMin = min(ymain_data(1),yX_data(1));
                yMax = max(ymain_data(end),yX_data(end));
                plot(ax1, x_data, log(yX_data), x_data, log(ymain_data));
                xlim([xMin xMax]);
                ylim([log(yMin) log(yMax)]);
                log_yTicks = linspace(log(yMin), log(yMax), 5);
                yTicks = exp(log_yTicks);
                yTickLabels = arrayfun(@(v) sprintf('%.2e', v), yTicks, 'UniformOutput', false);
                set(ax1, 'YTick', log_yTicks, 'YTickLabel', yTickLabels);
                legend(ax1, 'Impurity', 'Self');
                ylabel(ax1, 'D (m^2/s)');
                xlabel(ax1, '1000/T (K^{-1})');
            else
                ReadWfactor([0,1]);
                ReadWfactor([0,2]);
                %path4 = ['../',filename_main,'/f_extract_HCP.m'];
                path5 = ['../',filename_main,'/f_HCP.dat'];
                %copyfile (path4, '.');
                copyfile (path5, '.');
                cd ..
                cd (filename_main)
                cd (impurity)
                copyfile ('../readFreq.m','.')
                readFreq
                cd ..
                ReadWfactor([0,6]);
                ReadWfactor([0,7]);
                ReadWfactor([0,8]);
                ReadWfactor([0,9]);
                ReadWfactor([1,2]);
                ReadWfactor([1,3]);
                ReadWfactor([1,4]);
                ReadWfactor([1,5]);
                T_init= get(findobj('Style', 'edit', 'Position', [490, 330, 35, 27]), 'String');
                T_init = str2double(T_init);
                T_end= get(findobj('Style', 'edit', 'Position', [552, 330, 35, 27]), 'String');
                T_end = str2double(T_end);
                % Check if the inputs are valid numbers and within range
                if isnan(T_init) || isnan(T_end) || mod(T_init, 10) ~= 0 || T_init < 10 || T_init > 2800 || mod(T_end, 10) ~= 0 || T_end < 10 || T_end > 2800
                    errordlg('Temperature must be a multiple of 10 between 10 and 2800.', 'Error');
                    return;
                end
                D_HCP([T_init,T_end]);
                D_results=dlmread('D.dat');
                x_data= D_results(:,2);
                y1_data=D_results(:,3);
                y2_data=D_results(:,4);
                y3_data=D_results(:,5);
                y4_data=D_results(:,6);
                xMin = x_data(end);
                xMax = x_data(1);
                yMin = min([y1_data(1),y2_data(1),y3_data(1),y4_data(1)]);
                yMax = max([y1_data(end),y2_data(end),y3_data(end),y4_data(end)]);
                plot(ax1, x_data, log(y1_data),x_data,log(y2_data),x_data,log(y3_data),x_data,log(y4_data));
                xlim([xMin xMax]);
                ylim([log(yMin) log(yMax)]);
                log_yTicks = linspace(log(yMin), log(yMax), 5);
                yTicks = exp(log_yTicks);
                yTickLabels = arrayfun(@(v) sprintf('%.2e', v), yTicks, 'UniformOutput', false);
                set(ax1, 'YTick', log_yTicks, 'YTickLabel', yTickLabels);
                legend(ax1, 'Self\_Basal','Self\_C','Impurity\_Basal','Impurity\_Z');
                ylabel(ax1, 'D (m^2/s)');
                xlabel(ax1, '1000/T (K^{-1})');
            end
        end
        
        createCustomMessageBox('Run successfully', 'Tips',12,[300, 300, 300, 150]);
        function createCustomMessageBox(message, title, fontSize, position)
            d = dialog('Position', position, 'Name', title);
            
            % Dynamically calculates the position and size of text controls
            txt = uicontrol('Parent', d, 'Style', 'text', ...
                'Position', [20, position(4)-70, position(3)-40, 40], ...
                'String', message, ...
                'FontSize', fontSize);
            
            btn = uicontrol('Parent', d, ...
                'Position', [(position(3)-70)/2, 20, 70, 25], ...
                'String', 'Close', ...
                'Callback', @(src, event) delete(d));
        end
        function closeDialog(d)
            delete(d);
        end
    end


    function getD_interCallback(src, eventdata)
        popupHandle = findobj('Tag', 'myPopupMenu');
        popupOptions = get(popupHandle, 'String');
        selectedIndex = get(popupHandle, 'Value');
        if iscell(popupOptions)
            structure = popupOptions{selectedIndex};
        else
            error('Popup menu options are not in cell array format.');
        end
        path = get(findobj('Style', 'edit', 'Position', [562, 375, 101, 27]), 'String');
        XConc_init = get(findobj('Style', 'edit', 'Position', [563, 285, 35, 27]), 'String');
        XConc_end = get(findobj('Style', 'edit', 'Position', [625, 285, 35, 27]), 'String');
        XConc_init = str2double(XConc_init);
        XConc_end = str2double(XConc_end);
        % Check if the inputs are valid integers and within the range 0-100
        if isnan(XConc_init) || isnan(XConc_end) || mod(XConc_init, 1) ~= 0 || mod(XConc_end, 1) ~= 0 || XConc_init < 0 || XConc_init > 100 || XConc_end < 0 || XConc_end > 100
            errordlg('Concentration values must be integers between 0 and 100.', 'Error');
            return;
        end
        
        % Check if the two values are different
        if XConc_init == XConc_end
            errordlg('Concentration values must be different.', 'Error');
            return;
        end
        XConc_init = XConc_init/100;
        XConc_end = XConc_end/100;
        Conc = (XConc_init:0.01:XConc_end);
        T_input = get(findobj('Style', 'edit', 'Position', [490, 240, 35, 27]), 'String');
        T_output = T_input;
        T_input = str2double(T_input);
        cd (path);
        dat=dlmread('D.dat');
        T=dat(:,1);
        tol = 1e-6;
        indices = find(abs(T - T_input) < tol);
        activity=dlmread('thermofactor.dat');
        conc_test=activity(:,1);
        indices2 = find(abs(XConc_init-conc_test) < tol);
        indices3 = find(abs(XConc_end-conc_test) < tol);
        % Check if indices2 or indices3 are empty
        if isempty(indices2) || isempty(indices3)
            errordlg('No corresponding concentration found. Please input a correctly formatted thermofactor.dat with a concentration interval of 0.01.', 'Error');
            return;
        end
        ln_conc = log(activity(indices2:indices3,1));
        ln_activity = log (activity(indices2:indices3,2));
        fai =1+ diff(ln_activity) ./ diff(ln_conc)
        n = length (fai);
        fai(n+1)=fai(n);
        interD=zeros(length(Conc),1);
        S=zeros(length(Conc),1);
        if strcmp(structure, 'FCC')
            D_main=dat(indices,4);
            D_x=dat(indices,3);
            for j=1:length(Conc)
                if j==1
                    S(j)=1+0.2796.*(((Conc(j).*(1-Conc(j))).*(D_main-D_x).^2)./(((1-Conc(j)).*D_main+Conc(j).*D_x).*(Conc(j).*D_main+(1-Conc(j)).*D_x)));
                    interD(j)=(D_x.*(1-Conc(j))+D_main.*Conc(j)).*S(j)*fai(j+1);
                else
                    S(j)=1+0.2796.*(((Conc(j).*(1-Conc(j))).*(D_main-D_x).^2)./(((1-Conc(j)).*D_main+Conc(j).*D_x).*(Conc(j).*D_main+(1-Conc(j)).*D_x)));
                    interD(j)=(D_x.*(1-Conc(j))+D_main.*Conc(j)).*S(j)*fai(j);
                end
            end
            xMin = Conc(1);
            xMax = Conc(end);
            yMin = min(interD);
            yMax = max(interD);
            plot(ax2,Conc,interD);
            %semilogy(ax2,Conc,interD);
            %log_yTicks = linspace(yMin, yMax, 5);
            %yTicks = log_yTicks;
            %yTickLabels = arrayfun(@(v) sprintf('%.2e', v), yTicks, 'UniformOutput', false);
            %set(ax2, 'YTick', log_yTicks, 'YTickLabel', yTickLabels);
            lengedname=strcat(T_output,'K');
            legend(ax2,lengedname);
            xlim([xMin xMax]);
            ylim([yMin yMax]);
            xlabel(ax2, 'X Conc.');
            ylabel(ax2, 'D (m^2/s)');
            dname=strcat('interD_',T_output,'.dat')
            Conc=Conc';
            out=cat(2,Conc,interD);
            dlmwrite(dname,out,'delimiter','\t','precision','%.20e');
        elseif strcmp(structure, 'BCC')
            D_main=dat(indices,4)
            D_x=dat(indices,3);
            for j=1:length(Conc)
                if j==1
                    S(j)=1+0.3751.*(((Conc(j).*(1-Conc(j))).*(D_main-D_x).^2)./(((1-Conc(j)).*D_main+Conc(j).*D_x).*(Conc(j).*D_main+(1-Conc(j)).*D_x)));
                    interD(j)=(D_x.*(1-Conc(j))+D_main.*Conc(j)).*S(j)*fai(j+1);
                else
                    S(j)=1+0.3751.*(((Conc(j).*(1-Conc(j))).*(D_main-D_x).^2)./(((1-Conc(j)).*D_main+Conc(j).*D_x).*(Conc(j).*D_main+(1-Conc(j)).*D_x)));
                    interD(j)=(D_x.*(1-Conc(j))+D_main.*Conc(j)).*S(j)*fai(j);
                end
            end
            
            dname=strcat('interD_',T_output,'.dat');
            Conc=Conc';
            out=cat(2,Conc,interD);
            dlmwrite(dname,out,'delimiter','\t','precision','%.20e');
            dat = dlmread(dname);
            Conc = dat(:,1);
            inter = dat(:,2);
            xMin = Conc(1);
            xMax = Conc(end);
            yMin = min(inter);
            yMax = max(inter);
            plot(ax2,Conc,inter);
            %semilogy(ax2,Conc,inter);
            %log_yTicks = linspace(yMin, yMax, 5);
            %yTicks = log_yTicks;
            %yTickLabels = arrayfun(@(v) sprintf('%.2e', v), yTicks, 'UniformOutput', false);
            %set(ax2, 'YTick', log_yTicks, 'YTickLabel', yTickLabels);
            lengedname=strcat(T_output,'K');
            legend(ax2,lengedname);
            xlim([xMin xMax]);
            ylim([yMin yMax]);
            xlabel(ax2, 'X Conc.');
            ylabel(ax2, 'D (m^2/s)');
        else
            D_main1=dat(indices,3);
            D_x1=dat(indices,5);
            D_main2=dat(indices,4);
            D_x2=dat(indices,6);
            interD1=zeros(length(Conc),1);
            for j=1:length(Conc)
                if j==1
                    S1(j)=1+0.25.*(((Conc(j).*(1-Conc(j))).*(D_main1-D_x1).^2)./(((1-Conc(j)).*D_main1+Conc(j).*D_x1).*(Conc(j).*D_main1+(1-Conc(j)).*D_x1)));
                    S2(j)=1+0.25.*(((Conc(j).*(1-Conc(j))).*(D_main2-D_x2).^2)./(((1-Conc(j)).*D_main2+Conc(j).*D_x2).*(Conc(j).*D_main2+(1-Conc(j)).*D_x2)));
                    interD(j)=(D_x1.*(1-Conc(j))+D_main1.*Conc(j)).*S1(j)*fai(j+1);
                    interD1(j)=(D_x2.*(1-Conc(j))+D_main2.*Conc(j)).*S2(j)*fai(j+1);
                else
                    S1(j)=1+0.25.*(((Conc(j).*(1-Conc(j))).*(D_main1-D_x1).^2)./(((1-Conc(j)).*D_main1+Conc(j).*D_x1).*(Conc(j).*D_main1+(1-Conc(j)).*D_x1)));
                    S2(j)=1+0.25.*(((Conc(j).*(1-Conc(j))).*(D_main2-D_x2).^2)./(((1-Conc(j)).*D_main2+Conc(j).*D_x2).*(Conc(j).*D_main2+(1-Conc(j)).*D_x2)));
                    interD(j)=(D_x1.*(1-Conc(j))+D_main1.*Conc(j)).*S1(j)*fai(j);
                    interD1(j)=(D_x2.*(1-Conc(j))+D_main2.*Conc(j)).*S2(j)*fai(j);
                end
            end
            xMin = Conc(1);
            xMax = Conc(end);
            Y_1=cat(1,interD1,interD);
            yMin = min(Y_1);
            yMax = max(Y_1);
            
            plot(ax2,Conc,interD,Conc,interD1);
            %semilogy(ax2,Conc,interD,Conc,interD1);
            %log_yTicks = linspace(yMin, yMax, 5);
            %yTicks = log_yTicks;
            %yTickLabels = arrayfun(@(v) sprintf('%.2e', v), yTicks, 'UniformOutput', false);
            %set(ax2, 'YTick', log_yTicks, 'YTickLabel', yTickLabels);
            lengedname1=strcat(T_output,'K\_XY');
            lengedname2=strcat(T_output,'K\_Z');
            legend(ax2,lengedname1,lengedname2);
            xlim([xMin xMax]);
            ylim([yMin yMax]);
            xlabel(ax2, 'X Conc.');
            ylabel(ax2, 'D (m^2/s)');
            dname=strcat('interD_',T_output,'.dat')
            Conc=Conc';
            out=cat(2,Conc,interD,interD1);
            dlmwrite(dname,out,'delimiter','\t','precision','%.20e');
        end
        
    end

end

