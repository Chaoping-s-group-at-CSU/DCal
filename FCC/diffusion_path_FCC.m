function diffusion_path_FCC
global impurity Ele
currentPath = pwd;
addpath(currentPath);
filename = fullfile([Ele '-X' ]);
mkdir (filename);
cd (filename);
mkdir (Ele);
cd (Ele);
mkdir ('ori');
cd ('ori');
copyfile('../../../POSCAR', '.');
cd ..
mkdir ('w0');
cd ('w0');
copyfile ('../../../w0_self.m', '.');
copyfile('../../../POSCAR', 'POSCAR0');
% Check the folder for files that start with "POSCAR"
files = dir('POSCAR');
if ~isempty(files)
    % If there are files that start with "POSCAR", delete them
    for i = 1:length(files)
        delete(files(i).name);
    end
else

end

w0_self;
cd ..
mkdir ('w1');
cd ('w1');
copyfile ('../../../w1_self.m', '.');
copyfile('../../../POSCAR', 'POSCAR0');
files = dir('POSCAR');
if ~isempty(files)
    for i = 1:length(files)
        delete(files(i).name);
    end
else

end
w1_self;
cd ..
cd ..
filename1 = fullfile([Ele '-' impurity]);
mkdir (filename1);
cd (filename1);
mkdir (impurity);
cd (impurity);
copyfile ('../../../impurity_generate.m', '.');
copyfile('../../../POSCAR', 'POSCAR0');
files = dir('POSCAR');
if ~isempty(files)
    for i = 1:length(files)
        delete(files(i).name);
    end
else

end
impurity_generate;
cd ..
for i  =0:3
    num = num2str(i);
    filename2 = fullfile(['w' num]);
    mkdir (filename2);
    cd (filename2);
    path = fullfile(['../../../' filename2 '.m']);
    copyfile (path, '.');
copyfile('../../../POSCAR', 'POSCAR0');
files = dir('POSCAR');
if ~isempty(files)
    for i = 1:length(files)
        delete(files(i).name);
    end
else

end
eval(['w' num]);
cd ..
end



