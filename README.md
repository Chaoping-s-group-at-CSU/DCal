# DCal.app 1.0

An open source Octave code for determining tracer diffusion coefficients, interdiffusion coefficients, and atomic mobilities in FCC, BCC, and HCP alloys. It features a user-friendly graphical user interface (GUI) with four key functions: generating perfect structures for pure FCC, BCC, or HCP metals; generating initial and final states fpr each diffusion path based on diffusion models; calculating tracer diffusion coefficients; and calculating interdiffusion coefficients.

## Directory structure 
* DCal.m: The main function that launches the GUI for DCal.app.
* D_FCC.m: Calculating tracer diffusion coefficients and atomic mobility data for FCC alloys.
* D_BCC.m: Calculating tracer diffusion coefficients and atomic mobility data for BCC alloys.
* D_HCP.m: Calculating tracer diffusion coefficients and atomic mobility data for HCP alloys.
* D_FCC_self.m: Calculating tracer diffusion coefficients and atomic mobility data for FCC pure metals.
* D_BCC_self.m: Calculating tracer diffusion coefficients and atomic mobility data for BCC pure metals.
* D_HCP_self.m: Calculating tracer diffusion coefficients and atomic mobility data for HCP pure metals.
* ReadWfactor.m: Calculating jump frequency for specific diffusion paths.
* readFreq.m: Obtaining entropy, enthalpy, free energy of each diffusion state.
* f_HCP.dat: Correlation factors for self_diffusion in HCP alloys.
* FCC
  - diffusion_path_FCC.m: Generating the initial and final state structures for each diffusion path in FCC alloys.
  - import_poscar.m: Importing a VASP POSCAR/CONTCAR file and extract structure information for use in 'supercell.m'.
  - supercell.m: Creating a supercell by replicating a geometry.
  - export_poscar.m: Exporting a geometry structure as a VASP POSCAR file.
  - w0_self.m: Generating the initial structure file for the self-diffusion path in pure FCC metals.
  - w1_self.m: Generating the final structure file for the self-diffusion path in pure FCC metals.
  - w0.m: Generating the initial structure file for the w1 (vacancy diffusion within the first nearest neighbor sites of the imurity atom), w2 (impurity atom diffusion), and w3 (vacancy diffusion away from the impurity atom) paths in FCC alloys.
  - w1.m: Generating the final structure file for the w1 path in FCC alloys.
  - w2.m: Generating the final structure file for the w2 path in FCC alloys.
  - w3.m: Generating the final structure file for the w3 path in FCC alloys.
  - impurity_generate.m: Generating the structure file with one substitutional impurity atom in pure FCC metals.
  - FCC_POSCAR_ORI: The initial structure file in POSCAR format requires replacing the lattice information to generate the unit cell POSCAR file for pure FCC metals.    
* BCC
  - diffusion_path_BCC.m: Generating the initial and final state structures for each diffusion path in BCC alloys.
  - import_poscar.m: Importing a VASP POSCAR/CONTCAR file and extract structure information for use in 'supercell.m'.
  - supercell.m: Creating a supercell by replicating a geometry.
  - export_poscar.m: Exporting a geometry structure as a VASP POSCAR file.
  - w0_self.m: Generating the initial structure file for the self-diffusion path in pure BCC metals.
  - w1_self.m: Generating the final structure file for the self-diffusion path in pure BCC metals.
  - w0.m: Generating the initial structure file for the w2 (impurity atom diffusion), w3 (vacancy diffusion from the first nearest neighbor sites to the second nearest neighbor sites of the impurity atom), and w4 (vacancy diffusion from the first nearest neighbor sites to the third or higehr neighbor sites of the impurity atom) paths in BCC alloys.
  - w2.m: Generating the final structure file for the w2 path in BCC alloys.
  - w3.m: Generating the final structure file for the w3 path in BCC alloys.
  - w4.m: Generating the final structure file for the w4 path in BCC alloys.
  - w5.m: Generating the final structure file for the w5 (vacancy diffuison from the second nearest neighbor sites to the higher neighbor sites of the impurity atom) path in BCC alloys.
  - impurity_generate.m: Generating the structure file with one substitutional impurity atom in pure BCC metals.
  - BCC_POSCAR_ORI: The initial structure file in POSCAR format requires replacing the lattice information to
    generate the unit cell POSCAR file for pure BCC metals.
* HCP
  - diffusion_path_HCP.m: Generating the initial and final state structures for each diffusion path in HCP alloys.
  - import_poscar.m: Importing a VASP POSCAR/CONTCAR file and extract structure information for use in 'supercell.m'.
  - supercell.m: Creating a supercell by replicating a geometry.
  - export_poscar.m: Exporting a geometry structure as a VASP POSCAR file.
  - w0_self.m: Generating the initial structure file for the self-diffusion path in pure HCP metals.
  - w1_self.m: Generating the final structure file for the self-diffusion path within a basal plane in pure HCP metals.
  - w2_self.m: Generating the final structure file for the self-diffusion path in different basal planes in pure HCP metals.
  - w0.m: Generating the initial structure file in which the impurity atom and vacancy are in different basal planes for the w6 (vacancy diffusion in different planes and keeping the nearest neighbor to the impurity atom), w7 (vacancy diffusion within a basal plane and keeping the nearest neighbor to the impurity atom), w8 (vacancy diffusion away from the impurity atom), and w9 (impurity atom diffusion).
  - w1.m: Generating the initial structure file in which the impurity atom and vacancy are in a basal plane for the w2 (vacancy diffusion in different planes and keeping the nearest neighbor to the impurity atom), w3 (vacancy diffusion within a basal plane and keeping the nearest neighbor to the impurity atom), w4 (vacancy diffusion away from the impurity atom), and w5 (impurity atom diffusion).
  - w2.m: Generating the final structure file for the w2 path in HCP alloys.
  - w3.m: Generating the final structure file for the w3 path in HCP alloys.
  - w4.m: Generating the final structure file for the w4 path in HCP alloys.
  - w5.m: Generating the final structure file for the w5 path in HCP alloys.
  - w6.m: Generating the final structure file for the w6 path in HCP alloys.
  - w7.m: Generating the final structure file for the w7 path in HCP alloys.
  - w8.m: Generating the final structure file for the w8 path in HCP alloys.
  - w9.m: Generating the final structure file for the w9 path in HCP alloys.
  - impurity_generate.m: Generating the structure file with one substitutional impurity atom in pure HCP metals.
  - HCP_POSCAR_ORI: The initial structure file in POSCAR format requires replacing the lattice information to
    generate the unit cell POSCAR file for pure HCP metals.
* example: Input and output example files in the following examples.

## Setting things up
* Install GNU Octave 9.2.0 or a newer verision on a 32/64-bit Windows system.
* Download the 'Octave version' directory.
* Open Octave and run DCal.m.

## Examples 
All input and output files in these examples are provided in the '.\example\' package.
### Example #1: Generating the perfect FCC_Al 2×2×2 supercell.
* Set the crystal structure 'FCC' from the 'Structure' drop-down menu;
* Enter the matrix element (Al), lattice constant (4 4 4), and supercell size (2 2 2) in the 'Matrix element', 'a b c', and 'Supercell' fields, respectively;
* Click the 'Generate initial structure' button.
  The unit cell POSCAR file is saved as 'POSCAR_FCC_unit' in the '.\FCC\' path, and the supercell POSCAR file is saved as 'POSCAR_FCC_Al' in the same respective paths.

### Example #2: Generating the perfect BCC_W 3×3×3 supercell.
* Set the crystal structure 'BCC' from the 'Structure' drop-down menu;
* Enter the matrix element (W), lattice constant (4 4 4), and supercell size (3 3 3) in the 'Matrix element', 'a b c', and 'Supercell' fields, respectively;
* Click the 'Generate initial structure' button.
  The unit cell POSCAR file is saved as 'POSCAR_BCC_unit' in the '.\BCC\' path, and the supercell POSCAR file is saved as 'POSCAR_BCC_W' in the same respective paths.

### Example #3: Generating the perfect HCP_Ti 3×3×2 supercell.
* Set the crystal structure 'HCP' from the 'Structure' drop-down menu;
* Enter the matrix element (Ti), lattice constant (3 3 4), and supercell size (3 3 2) in the 'Matrix element', 'a b c', and 'Supercell' fields, respectively;
* Click the 'Generate initial structure' button.
  The unit cell POSCAR file is saved as 'POSCAR_HCP_unit' in the '.\HCP\' path, and the supercell POSCAR file is saved as 'POSCAR_HCP_Ti' in the same respective paths.
  
### Example #4: Generating the initial and final states of each diffusion path in FCC Al-Fe alloys.
* Copy the relaxed perfect FCC supercell file named as 'POSCAR' to the '.\FCC\' path;
* Set the crystal structure 'FCC' from the 'Structure' drop-down menu;
* Enter the matrix element (Al), impurity element (Fe), and supercell size (the same size as copied POSCAR file) in the 'Matrix element', 'Impurity element', and 'Supercell' fields, respectively;
* Click the 'Generate paths' button.
  The initial and final states POSCAR files of each path are saved in '.\FCC\Al-X\Al-Fe\' directories.

### Example #5: Generating the initial and final states of each diffusion path in BCC W-Mo alloys.
* Copy the relaxed perfect BCC supercell file named as 'POSCAR' to the '.\BCC\' path;
* Set the crystal structure 'BCC' from the 'Structure' drop-down menu;
* Enter the matrix element (W), impurity element (Mo), and supercell size (the same size as copied POSCAR file) in the 'Matrix element', 'Impurity element', and 'Supercell' fields, respectively;
* Click the 'Generate paths' button.
  The initial and final states POSCAR files of each path are saved in '.\BCC\W-X\W-Mo\' directories.
  
### Example #6: Generating the initial and final states of each diffusion path in HCP Ti-Al alloys.
* Copy the relaxed perfect HCP supercell file named as 'POSCAR' to the '.\HCP\' path;
* Set the crystal structure 'HCP' from the 'Structure' drop-down menu;
* Enter the matrix element (Ti), impurity element (Al), and supercell size (the same size as copied POSCAR file) in the 'Matrix element', 'Impurity element', and 'Supercell' fields, respectively;
* Click the 'Generate paths' button.
  The initial and final states POSCAR files of each path are saved in '.\HCP\Ti-X\Ti-Al\' directories.
  
### Example #7: Calculating tracer diffusion coefficients and mobility data in in FCC Al-Mg alloy.
* Copy the results from the first-principles calculation to the your self-defined path 'your path\Al-X\'. The directory structure in 'your path\Al-X\' must match that of examples #3-6.
* Set the crystal structure 'FCC' from the 'Structure' drop-down menu;
* Enter the matrix element (Al), impurity element (Mg), and supercell size (the same size as copied POSCAR file) in the 'Matrix element', 'Impurity element', and 'Supercell' fields, respectively;
* Enter the path 'your path\Al-X\Al-Ti\' where the calculated results are stored in the 'Path' field;
* Enter the temperature range (300-900) in the 'T(K)' field to the left of the 'Get D' button;
* Click the 'Get D' button.
  After successfully running the programm, the tracer diffusion coefficients will be plotted on the left side of the GUI. The results are saved in 'your path\Al-X\Al-Mg\' directorty. The tracer diffusion coefficient results are saved named as 'D.dat', with six columns representing T, 1000/T, D_impurity, D_self_diffusion data, vacancy concentration with an impurity atom in its nearest neighboring site,and vacancy concentration in pure Al, respectively. The mobility data are saved as 'MQ_tdb.dat'. The correlation factors are saved in the last column of 'f-Factor.dat'. The jump frequencies for each path are saved in the last column of 'iToj.dat'.
  If the user only wants to get the self-diffusion data of Al, the 'Impurity element' field should be filled with 'none'. The calculated results will then be saved in the user-defined path 'your path\Al-X\Al\'.The self-diffusion coefficient results are saved named as 'D_self.dat', with four columns representing T, 1000/T, D_self_diffusion data,and vacancy concentration in pure Al, respectively. The mobility data are saved as 'MQ_tdb_self.dat'. The jump frequencies for each path are saved in the last column of 'iToj.dat'.
All post-processing results of Al-Mg alloy or pure Al metal are saved in '.\example\FCC\AlMg_D_results\' directory.
  
### Example #8: Calculating tracer diffusion coefficients and mobility data in in BCC W-Mo alloy.
* Copy the results from the first-principles calculation to the your self-defined path 'your path\W-X\'. The directory structure in 'your path\W-X\' must match that of examples #3-6.
* Set the crystal structure 'BCC' from the 'Structure' drop-down menu;
* Enter the matrix element (W), impurity element (Mo), and supercell size (the same size as copied POSCAR file) in the 'Matrix element', 'Impurity element', and 'Supercell' fields, respectively;
* Enter the path 'your path\W-X\W-Mo\' where the calculated results are stored in the 'Path' field;
* Enter the temperature range (300-2000) in the 'T(K)' field to the left of the 'Get D' button;
* Click the 'Get D' button.
  After successfully running the programm, the tracer diffusion coefficients will be plotted on the left side of the GUI. The results are saved in 'your path\W-X\W-Mo\' directorty. The tracer diffusion coefficient results are saved named as 'D.dat', with six columns representing T, 1000/T, D_impurity, D_self_diffusion data, vacancy concentration with an impurity atom in its nearest neighboring site,and vacancy concentration in pure W, respectively. The mobility data are saved as 'MQ_tdb.dat'. The correlation factors are saved in the last column of 'f-Factor.dat'. The jump frequencies for each path are saved in the last column of 'iToj.dat'.
  If the user only wants to get the self-diffusion data of W, the 'Impurity element' field should be filled with 'none'. The calculated results will then be saved in the user-defined path 'your path\W-X\W\'.The self-diffusion coefficient results are saved named as 'D_self.dat', with four columns representing T, 1000/T, D_self_diffusion data,and vacancy concentration in pure W, respectively. The mobility data are saved as 'MQ_tdb_self.dat'. The jump frequencies for each path are saved in the last column of 'iToj.dat'.
All post-processing results of W-Mo alloy or pure Al metal are saved in '.\example\BCC\WMo_D_results\' directory.

### Example #9: Calculating tracer diffusion coefficients and mobility data in in HCP Ti-Al alloy.
* Copy the results from the first-principles calculation to the your self-defined path 'your path\Ti-X\'. The directory structure in 'your path\Ti-X\' must match that of examples #3-6.
* Set the crystal structure 'HCP' from the 'Structure' drop-down menu;
* Enter the matrix element (Ti), impurity element (Al), and supercell size (the same size as copied POSCAR file) in the 'Matrix element', 'Impurity element', and 'Supercell' fields, respectively;
* Enter the path 'your path\Ti-X\Ti-Al\' where the calculated results are stored in the 'Path' field;
* Enter the temperature range (300-1500) in the 'T(K)' field to the left of the 'Get D' button;
* Click the 'Get D' button.
  After successfully running the programm, the tracer diffusion coefficients will be plotted on the left side of the GUI. The results are saved in 'your path\Ti-X\Ti-Al\' directorty. The tracer diffusion coefficient results are saved named as 'D.dat', with eight columns representing T, 1000/T, D_self_basal, D_self_Z, D_impurity_basal, D_impurity_Z, vacancy concentration with an impurity atom in its nearest neighboring site,and vacancy concentration in pure Ti, respectively. The mobility data are saved as 'MQ_basal_tdb.dat' and  'MQ_Z_tdb.dat'. The correlation factors of impurity diffusion (fbz, fbx, fax) are saved in 'f-Factor.dat', and the correlation factor of Ti self-diffusion (fax, fbx, fbz) are saved in 'f.dat'. The jump frequencies for each path are saved in the last column of 'iToj.dat'.
  If the user only wants to get the self-diffusion data of Ti, the 'Impurity element' field should be filled with 'none'. The calculated results will then be saved in the user-defined path 'your path\Ti-X\Ti\'.The self-diffusion coefficient results are saved named as 'D_self.dat', with five columns representing T, 1000/T, D_self_basal, D_self_Z ,and vacancy concentration in pure Ti, respectively. The mobility data are saved as 'MQ_tdb_self.dat'. The jump frequencies for each path are saved in the last column of 'iToj.dat'.
All post-processing results of Ti-Al alloy or pure Ti metal are saved in '.\example\HCP\TiAl_D_results\' directory.

### Example #10: Calculating interdiffusion coefficients in FCC Al-Mg alloy.
* Prepare the 'thermofactor.dat' file in your self-defined path 'your path\Al-X\Al-Mg\'. This file should contain two columns data: the concentration of impurity atoms and the corresponding activity data at each concentration.
* Copy the 'D.dat' results from examles #7-10 to your self-defined path 'your path\Al-X\Al-Mg\'.
* Set the crystal structure 'FCC' from the 'Structure' drop-down menu;
* Enter the path 'your path\Al-X\Al-Mg\' where the 'thermofactor.dat' and  'D.dat' are stored in the 'Path' field;
* Enter the composition range (0-10) in the 'X Conc. (at. %)' field;
* Enter the temperature (700) in the 'T(K)' field to the left of the 'Get D_inter' button;
* Click the 'Get D_inter' button.
  After successfully running the programm, the interdiffusion coefficients will be plotted on the right side of the GUI. The results are saved in 'your path\Al-X\Al-Mg\' directorty. The interdiffusion coefficient results are saved named as 'interD_700.dat', with two columns representing impurity concentration, and interdiffusion coefficients, respectively.

### Example #11: Calculating interdiffusion coefficients in BCC W-Mo alloy.
* Prepare the 'thermofactor.dat' file in your self-defined path 'your path\W-X\W-Mo\'. This file should contain two columns data: the concentration of impurity atoms and the corresponding activity data at each concentration.
* Copy the 'D.dat' results from examles #7-10 to your self-defined path 'your path\W-X\W-Mo\'.
* Set the crystal structure 'BCC' from the 'Structure' drop-down menu;
* Enter the path 'your path\W-X\W-Mo\' where the 'thermofactor.dat' and  'D.dat' are stored in the 'Path' field;
* Enter the composition range (0-10) in the 'X Conc. (at. %)' field;
* Enter the temperature (1600) in the 'T(K)' field to the left of the 'Get D_inter' button;
* Click the 'Get D_inter' button.
  After successfully running the programm, the interdiffusion coefficients will be plotted on the right side of the GUI. The results are saved in 'your path\W-X\W-Mo\' directorty. The interdiffusion coefficient results are saved named as 'interD_1600.dat', with two columns representing impurity concentration, and interdiffusion coefficients, respectively.

### Example #12: Calculating interdiffusion coefficients in HCP Ti-Al alloy.
* Prepare the 'thermofactor.dat' file in your self-defined path 'your path\Ti-X\Ti-Al\'. This file should contain two columns data: the concentration of impurity atoms and the corresponding activity data at each concentration.
* Copy the 'D.dat' results from examles #7-10 to your self-defined path 'your path\Ti-X\Ti-Al\'.
* Set the crystal structure 'HCP' from the 'Structure' drop-down menu;
* Enter the path 'your path\Ti-X\Ti-Al\' where the 'thermofactor.dat' and  'D.dat' are stored in the 'Path' field;
* Enter the composition range (0-8) in the 'X Conc. (at. %)' field;
* Enter the temperature (1000) in the 'T(K)' field to the left of the 'Get D_inter' button;
* Click the 'Get D_inter' button.
  After successfully running the programm, the interdiffusion coefficients will be plotted on the right side of the GUI. The results are saved in 'your path\Ti-X\Ti-Al\' directorty. The interdiffusion coefficient results are saved named as 'interD_1000.dat', with two columns representing impurity concentration, and interdiffusion coefficients, respectively.
