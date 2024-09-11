
function D_HCP_self(x)
global Element m n p
k=8.617343*10^(-5);
T=0:10:2800;T=T';t=1000./T;
cd('ori');
Thermal=dlmread('ThermoData.dat');Gp=Thermal(:,4); %perfect crystal
B=dlmread('CONTCAR','',[1,0,1,0]);
A=dlmread('CONTCAR','',[2,0,2,0]);a=2*A.*B/m;  %get lattice constant (3*3*3)
C=dlmread('CONTCAR','',[4,2,4,2]);c=C.*B/p;
atom_perfect = m*n*p*2;
atom = atom_perfect-1; 
cd ..
cd('w0');Thermal=dlmread('ThermoData.dat');Gv=Thermal(:,4);
dGf=Gv-atom*Gp/atom_perfect;Cv=exp(-1*dGf./(T.*k));
cd ..
DrawW([0,1;0,2]);freq=dlmread('v b w.dat');
wA=freq(:,5);wB=freq(:,6);
f_extract;
f=dlmread('f.dat');
fax=f(:,1);fbx=f(:,2);fbz=f(:,3);
D_self_basal=1/2.*Cv.*(a*10.^(-10))^2.*(3*fax.*wA+fbx.*wB);
D_self_C=3/4*Cv.*(c*10.^(-10))^2.*fbz.*wB;
ReadDir=x;
T_init=ReadDir(1);
T_end=ReadDir(2);
T_out=T_init:10:T_end;
t_out=1000./T_out;
T_out=T_out';
t_out=t_out';
line1=T_init/10+1;
line2=T_end/10+1;
D_self_basal_out=D_self_basal(line1:line2);
D_self_C_out=D_self_C(line1:line2);
Cv_out=Cv(line1:line2);
out=cat(2,T_out,t_out,D_self_basal_out,D_self_C_out,Cv_out);
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
MQ1 = sprintf('Parameter MQ(HCP&%s,%s;0)  298.15 %s+R*T*ln(%s); 6000 N !', Element, Element, a1, D0_1);
fileID = fopen('MQ_basal_tdb_self.dat', 'w');
fprintf(fileID, '%s\n', MQ1);
fclose(fileID);
x=dat(:,2);
y1=dat(:,4);
ln_y1=log(y1);
p1=polyfit(x,ln_y1,1);
slope1=p1(1);
intercept1=p1(2);
Q1=-slope1*0.08617;
D0_1=exp(intercept1);D0_1=num2str(D0_1, '%.2e');
a1=-96000*Q1;a1=num2str(a1, '%.2f');
MQ1 = sprintf('Parameter MQ(HCP&%s,%s;0)  298.15 %s+R*T*ln(%s); 6000 N !', Element, Element, a1, D0_1);
fileID = fopen('MQ_Z_tdb_self.dat', 'w');
fprintf(fileID, '%s\n', MQ1);
fclose(fileID);

function DrawW(x)
% extract the value of each jump frequency
% x can be DrawW([0,0;1,4;2,4;3,4;4,3])
Readfile=x;
m=size(x,1);
for i=1:m
    dat=strcat(int2str(Readfile(i,1)),'To',int2str(Readfile(i,2)),'.dat');
    freq=dlmread(dat);
    vstar(:,i)=freq(:,2);
    w(:,i)=freq(:,4);
   barrier(:,i)=freq(:,3);
end
out=cat(2,vstar,barrier,w);
dlmwrite('v b w.dat',out,'delimiter','\t','precision','%.20e');


function f_extract
f=dlmread('f_HCP.dat');
wA=dlmread('0To1.dat');
wA=wA(:,4);
wB=dlmread('0To2.dat');
wB=wB(:,4);
h=length(wA);
f1=f(:,1);
fax=zeros(h,1);
fbx=zeros(h,1);
fbz=zeros(h,1);
for i = 2:h
    if wA(i)/wB(i)<1
        k=wA(i)/wB(i);
        k=sprintf('%.2f',k);
         k=str2num(k);
        line = find(f1==k);
        fax(i)=f(line,2);
        fbx(i)=f(line,3);
        fbz(i)=f(line,4);
    else
        k=wB(i)/wA(i);
        k=sprintf('%.2f',k);
        k=str2num(k);
        line = find(f1==k);
        fax(i)=f(line,5);
        fbx(i)=f(line,6);
        fbz(i)=f(line,7);
    end
end
out=cat(2,fax,fbx,fbz);
dlmwrite('f.dat',out,'delimiter','\t','precision','%.20e');



