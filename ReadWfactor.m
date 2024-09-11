function ReadWfactor(x)
%This programme is used to calculated w factor
%x should be in order of original Dir and transition Dir
%Enter Dir and Read files
kb=8.617343*10^(-5);%ev/K
global kb
ReadDir=x;
for i=1:length(ReadDir)
    dname=strcat('w',int2str(ReadDir(i)));
    cd (dname);
    if i==1
        [BeginThermo,begin]=readFreq;
        cd ..
    else
        [FinalThermo,final]=readFreq;
        cd ..
    end
end
%Enter NEB file and read enthalpy and frequency
dname=strcat(int2str(ReadDir(1)),'-',int2str(ReadDir(end)));
cd (dname);
neb=dlmread('neb.dat');
[h,i]=max(neb(:,3));
hbegin=h-neb(1,3);hfinal=h-neb(end,3);
dname=strcat('0',int2str(i-1));
cd (dname);
[MiddleThermo,middle]=readFreq;
cd ..
cd ..
%Calculate w-factor
wbegin=wfactor(begin,middle,hbegin);
%wBeginThermo=doubleWell(BeginThermo,MiddleThermo,hbegin);
wfinal=wfactor(final,middle,hfinal);
%wFingalThermo=doubleWell(FinalThermo,MiddleThermo,hfinal);
writename=strcat(int2str(ReadDir(1)),'To',int2str(ReadDir(end)),'.dat');
dlmwrite(writename, wbegin,  'delimiter', '\t', 'precision', '%.20e');
writename=strcat(int2str(ReadDir(end)),'To',int2str(ReadDir(1)),'.dat');
dlmwrite(writename, wfinal,  'delimiter', '\t', 'precision', '%.20e');

%writename=strcat(int2str(ReadDir(1)),'ToThermo',int2str(ReadDir(end)),'.dat');
%dlmwrite(writename, wBeginThermo,  'delimiter', '\t', 'precision', '%.20e');
%writename=strcat(int2str(ReadDir(end)),'ToThermo',int2str(ReadDir(1)),'.dat');
%dlmwrite(writename, wFingalThermo,  'delimiter', '\t', 'precision', '%.20e');

%subfunctions

function [out,oriFreq]=readFreq
cd ('vol_0');
oriFreq=dlmread('freq.dat');
cd ..
oriS=dlmread('svib');
oriF=dlmread('tfvib.out');
energy=dlmread('energy');
T=oriF(:,1);H=oriF(:,end)+T.*oriS;S=oriS;F=energy+oriF(:,end);
%output in sequence of Temperature enthalpy entropy freeenergy 
out=cat(2,T,H,S,F);
dlmwrite('ThermoData.dat', out,  'delimiter', '\t', 'precision', '%.10f');
return

function out=wfactor(ori,mid,htrans)
global kb
ori=sort(ori);ori=ori(5:end);
mid=sort(mid);mid=mid(6:end);
tst=zeros(length(mid),1);
for i=1:length(mid);
    tst(i)=ori(i)/mid(i);
end
multFreq=1;
for j=1:length(tst);
    multFreq=multFreq*tst(j);
end
multFreq=abs(multFreq*ori(end));
for i=10:10:2800
    t(i/10)=i;
    oriFreq(i/10)=multFreq;
    h(i/10)=htrans;
    w(i/10)=multFreq*exp(-htrans/(kb*i));
end
t=t';oriFreq=oriFreq';h=h';w=w';
wFactor=cat(2,t,oriFreq,h,w);
out=cat(1,[0,multFreq,htrans,0.0],wFactor);
return

function out=doubleWell(ori,mid,htrans)
deltaH=htrans+(mid(:,2)-ori(:,2));
deltaS=mid(:,3)-ori(:,3);
deltaF=mid(:,4)-ori(:,4);
for i=1:length(mid(:,1))
    if i==1 
        wfactor(i)=0;
    else
        wfactor(i)=(8.617343*10^(-5)*10^16.*mid(i,1)/6.58211928)*exp(-deltaF(i)./(8.617343*10^(-5).*mid(i,1)));
    end
end
wfactor=wfactor';
out=cat(2,deltaH,deltaS,deltaF,wfactor);
return