
function D_FCC_self(x)
global Element m n p
k=8.617343*10^(-5);
f0=0.7815;%Perfect FCC correlation factor
T=0:10:2800;T=T';t=1000./T;
atom_perfect = m*n*p*4;
atom = atom_perfect-1;
cd('ori');Thermal=dlmread('ThermoData.dat');Gp=Thermal(:,4);
A=dlmread('CONTCAR','',[2,0,2,0]);
B=dlmread('CONTCAR','',[1,0,1,0]);a=A.*B/m;
cd ..
cd('w0');Thermal=dlmread('ThermoData.dat');Gv=Thermal(:,4);
cd ..
copyfile('0To1.dat','0To0.dat');
dGf=Gv-atom*Gp/atom_perfect;
DrawW([0,0]);freq=dlmread('v b w.dat');
w0=freq(:,3);
Cv=exp(-1*dGf./(T.*k));
DIr=f0*(a*10.^(-10)).^2.*Cv.*w0;
ReadDir=x;
T_init=ReadDir(1);
T_end=ReadDir(2);
T_out=T_init:10:T_end;
t_out=1000./T_out;
T_out=T_out';
t_out=t_out';
line1=T_init/10+1;
line2=T_end/10+1;
DIr_out=DIr(line1:line2);
Cv_out=Cv(line1:line2);
out=cat(2,T_out,t_out,DIr_out,Cv_out);
dlmwrite('D_self.dat',out,'delimiter','\t','precision','%.20e');
dat=dlmread('D_self.dat');
x=dat(:,2);
y1=dat(:,3);
ln_y1=log(y1);
p1=polyfit(x,ln_y1,1);
slope1=p1(1);
intercept1=p1(2);
Q1=-slope1*0.08617;
D0_1=exp(intercept1);D0_1=num2str(D0_1, '%.2e');
a1=-96000*Q1;a1=num2str(a1, '%.2f');
MQ1 = sprintf('Parameter MQ(FCC&%s,%s;0)  298.15 %s+R*T*ln(%s); 6000 N !', Element, Element, a1, D0_1);
fileID = fopen('MQ_tdb_self.dat', 'w');
fprintf(fileID, '%s\n', MQ1);
fclose(fileID);


function DrawW(x)
% extract the value of each jump frequency
% x can be like DrawW([0,0;1,4;2,4;3,4;4,3])
Readfile=x;
freq=dlmread('0To0.dat');
vstar(:,1)=freq(:,2);
w(:,1)=freq(:,4);
barrier(:,1)=freq(:,3);
out=cat(2,vstar,barrier,w);
dlmwrite('v b w.dat',out,'delimiter','\t','precision','%.20e');

