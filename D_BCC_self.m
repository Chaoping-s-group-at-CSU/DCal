
function D_BCC_self(x)
global Element m n p
k=8.617343*10^(-5);
f0=0.7272;%Perfect BCC correlation factor
T=0:10:2800;T=T';t=1000./T;
cd('ori');
Thermal=dlmread('ThermoData.dat');Gp=Thermal(:,4); %perfect crystal
A=dlmread('CONTCAR','',[2,0,2,0]);
B=dlmread('CONTCAR','',[1,0,1,0]);
a=2*A.*B/m;
atom_perfect = m*n*p;
atom = atom_perfect-1;
cd ..
cd('w0');Thermal=dlmread('ThermoData.dat');Gv=Thermal(:,4);
cd ..
copyfile('0To1.dat','0To0.dat');
dGf=Gv-atom*Gp/atom_perfect;Cv=exp(-1*dGf./(T.*k));
DrawW([0,0]);freq=dlmread('v b w.dat');
b0=freq(:,2);
v0=freq(:,1);
w0=freq(:,3);
D_self=f0*(a*10.^(-10)).^2.*Cv.*w0;
ReadDir=x;
T_init=ReadDir(1);
T_end=ReadDir(2);
T_out=T_init:10:T_end;
t_out=1000./T_out;
T_out=T_out';
t_out=t_out';
line1=T_init/10+1;
line2=T_end/10+1;
D_self_out=D_self(line1:line2);
Cv_out=Cv(line1:line2);
out=cat(2,T_out,t_out,D_self_out,Cv_out);
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
MQ1 = sprintf('Parameter MQ(BCC&%s,%s;0)  298.15 %s+R*T*ln(%s); 6000 N !', Element, Element, a1, D0_1);
fileID = fopen('MQ_tdb_self.dat', 'w');
fprintf(fileID, '%s\n', MQ1);
fclose(fileID);

function DrawW(x)
        % extract the value of each jump frequency
        % x can be DrawW([0,0;1,4;2,4;3,4;4,3])
        Readfile=x;
        dat=strcat(int2str(Readfile(1)),'To',int2str(Readfile(2)),'.dat');
        freq=dlmread(dat);
        vstar(:,1)=freq(:,2);
        w(:,1)=freq(:,4);
        barrier(:,1)=freq(:,3);
out=cat(2,vstar,barrier,w);
dlmwrite('v b w.dat',out,'delimiter','\t','precision','%.20e');

