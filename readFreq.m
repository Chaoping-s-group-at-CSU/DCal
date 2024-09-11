function readFreq
cd ('vol_0');
oriFreq=dlmread('freq.dat');
energy=dlmread('energy');
cd ..
oriS=dlmread('svib');
oriF=dlmread('tfvib.out');
T=oriF(:,1);H=oriF(:,end)+T.*oriS;S=oriS;F=energy+oriF(:,end);
%output in sequence of Temperature enthalpy entropy freeenergy 
out=cat(2,T,H,S,F);
dlmwrite('ThermoData.dat', out,  'delimiter', '\t', 'precision', '%.10f');