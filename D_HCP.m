
function D_HCP(x)
global Element impurity path m n p
k=8.617343*10^(-5);
%  fax=0.57; fbx=1; fbz=1;%hcp
T=0:10:2800;T=T';t=1000./T;
cd ..
cd(Element);cd('ori');
Thermal=dlmread('ThermoData.dat');Hp=Thermal(:,2);Sp=Thermal(:,3);Gp=Thermal(:,4); %perfect crystal
B=dlmread('CONTCAR','',[1,0,1,0]);
A=dlmread('CONTCAR','',[2,0,2,0]);a=2*A.*B/m;  %get lattice constant (3*3*3)
C=dlmread('CONTCAR','',[4,2,4,2]);c=C.*B/p;
atom_perfect = m*n*p*2;
atom = atom_perfect-1;
copyfile('CONTCAR',path);
cd ..
cd('w0');Thermal=dlmread('ThermoData.dat');Hv=Thermal(:,2);Sv=Thermal(:,3);Gv=Thermal(:,4);
% copyfile('0To1.dat','0To0.dat');
% movefile('0To0.dat','D:\diffusion\BCC\W');%change path !!!
dGf=Gv-atom*Gp/atom_perfect;Cv=exp(-1*dGf./(T.*k));
cd ..
DrawW([0,1;0,2]);freq=dlmread('v b w.dat');
bA=freq(:,3);bB=freq(:,4);
vA=freq(:,1);vB=freq(:,2);
wA=freq(:,5);wB=freq(:,6);
f_extract;
f=dlmread('f.dat');
fax=f(:,1);fbx=f(:,2);fbz=f(:,3);
D_self_basal=1/2.*Cv.*(a*10.^(-10))^2.*(3*fax.*wA+fbx.*wB);
D_self_C=3/4*Cv.*(c*10.^(-10))^2.*fbz.*wB;
cd ..
cd ([Element,'-',impurity])
cd('w0');Thermal=dlmread('ThermoData.dat');Hiv=Thermal(:,2);Siv=Thermal(:,3);Giv=Thermal(:,4);
cd ..
cd (impurity);Thermal=dlmread('ThermoData.dat');Hi=Thermal(:,2);Si=Thermal(:,3);Gi=Thermal(:,4);
cd ..
dGb=Gi(1)+Gv(1)-Giv(1)-Gp(1);
dGfi=dGf-dGb;%dSfi=dSf-dSb;dHfi=dGfi+dSfi.*T;%concentration of vacancy nn to impurity
Civ=exp(-1*dGfi./(T.*k));
%we only use the value at 0K, dGb is a constant.
DrawW([0,9;0,6;0,7;0,8;1,5;1,2;1,3;1,4]);freq=dlmread('v b w.dat');  %0to0 is w0;0to2 is w2;0to3 is w3;3to0 is w4;0to4 is w3';3to5 is w5
bA=freq(:,9);bap=freq(:,10);bbp=freq(:,11);bcp=freq(:,12);bB=freq(:,13);ba=freq(:,14);bb=freq(:,15);bc=freq(:,16);
vA=freq(:,1);vap=freq(:,2);vbp=freq(:,3);vcp=freq(:,4);vB=freq(:,5);va=freq(:,6);;vb=freq(:,7);;vc=freq(:,8);
wA=freq(:,17);wap=freq(:,18);wbp=freq(:,19);wcp=freq(:,20);wB=freq(:,21);wa=freq(:,22);wb=freq(:,23);wc=freq(:,24);
Ffactor;
fac=dlmread('f-Factor.dat');fbz=fac(:,1);fbx=fac(:,2);fax=fac(:,3);
Dx=0.5*(a*10.^(-10)).^2.*Civ.*(3.*fax.*wA+fbx.*wB);
Dz=3/4.*Civ.*(c*10.^(-10)).^2.*fbz.*wB;
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
Dx_out=Dx(line1:line2);
Dz_out=Dz(line1:line2);
Civ_out=Civ(line1:line2);
Cv_out=Cv(line1:line2);
out=cat(2,T_out,t_out,D_self_basal_out,D_self_C_out,Dx_out,Dz_out,Civ_out,Cv_out);
dlmwrite('D.dat',out,'delimiter','\t','precision','%.20e');
dat=dlmread('D.dat');
x=dat(:,2);
y1=dat(:,5);
ln_y1=log(y1);
y2=dat(:,3);
ln_y2=log(y2);
p1=polyfit(x,ln_y1,1);
slope1=p1(1);
intercept1=p1(2);
p2=polyfit(x,ln_y2,1);
slope2=p2(1);
intercept2=p2(2);
Q1=-slope1*0.08617;
D0_1=exp(intercept1);D0_1=num2str(D0_1, '%.2e');
Q2=-slope2*0.08617;
D0_2=exp(intercept2);D0_2=num2str(D0_2, '%.2e');
a1=-96000*Q1;a1=num2str(a1, '%.2f');
a2=-96000*Q2;a2=num2str(a2, '%.2f');
MQ1 = sprintf('Parameter MQ(HCP&%s,%s;0)  298.15 %s+R*T*ln(%s); 6000 N !', impurity, Element, a1, D0_1);
MQ2 = sprintf('Parameter MQ(HCP&%s,%s;0)  298.15 %s+R*T*ln(%s); 6000 N !', Element, Element, a2, D0_2);
fileID = fopen('MQ_basal_tdb.dat', 'w');
fprintf(fileID, '%s\n', MQ1);
fprintf(fileID, '%s\n', MQ2);
fclose(fileID);
x=dat(:,2);
y1=dat(:,6);
ln_y1=log(y1);
y2=dat(:,4);
ln_y2=log(y2);
p1=polyfit(x,ln_y1,1);
slope1=p1(1);
intercept1=p1(2);
p2=polyfit(x,ln_y2,1);
slope2=p2(1);
intercept2=p2(2);
Q1=-slope1*0.08617;
D0_1=exp(intercept1);D0_1=num2str(D0_1, '%.2e');
Q2=-slope2*0.08617;
D0_2=exp(intercept2);D0_2=num2str(D0_2, '%.2e');
a1=-96000*Q1;a1=num2str(a1, '%.2f');
a2=-96000*Q2;a2=num2str(a2, '%.2f');
MQ1 = sprintf('Parameter MQ(HCP&%s,%s;0)  298.15 %s+R*T*ln(%s); 6000 N !', impurity, Element, a1, D0_1);
MQ2 = sprintf('Parameter MQ(HCP&%s,%s;0)  298.15 %s+R*T*ln(%s); 6000 N !', Element, Element, a2, D0_2);
fileID = fopen('MQ_Z_tdb.dat', 'w');
fprintf(fileID, '%s\n', MQ1);
fprintf(fileID, '%s\n', MQ2);
fclose(fileID)

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

function Ffactor
%Calculate the Ffactor of impurity diffusion
%Read w-factors
B=0.736;
A=dlmread('CONTCAR','',[2,0,2,0]);a=2*A/3;
wA=dlmread('0To9.dat');
wap=dlmread('0To6.dat');
wbp=dlmread('0To7.dat');
wcp=dlmread('0To8.dat');
wB=dlmread('1To5.dat');
wa=dlmread('1To2.dat');
wb=dlmread('1To3.dat');
wc=dlmread('1To4.dat');
wA=wA(:,4);wap=wap(:,4);wbp=wbp(:,4);wcp=wcp(:,4);wB=wB(:,4);wa=wa(:,4);wb=wb(:,4);wc=wc(:,4);
x0=[0,0,0];
options = optimset('Display', 'iter', ...
                   'MaxFunEvals', 20000, ...
                   'TolFun', 1e-40, ...
                   'TolX', 1e-40);B=0.736;
results=zeros(281,3);
K=length(wa);
for i =2:K
    F=@(x)[x(1)-(2*wap(i)*(3^0.5*x(2)/2+x(3)/2)+2*B*wbp(i)*(-0.5)*x(1)-wA(i)*(x(1)+a/(3^0.5)))/(2*wap(i)+2*wbp(i)+7*B*wcp(i)+wA(i));...
        x(2)-(2*wa(i)*3^0.5/2*x(1)+2*wb(i)*0.5*x(2)-wB(i)*(a+x(2)))/(2*wa(i)+2*wb(i)+7*B*wc(i)+wB(i));...
        x(3)-(2*wa(i)*0.5*x(1)+2*wb(i)*(-0.5)*x(3))/(2*wa(i)+2*wb(i)+7*B*wc(i)+wB(i))];
    [x,fval] = fsolve(F,x0,options);
    results(i,1)=x(1);
    results(i,2)=x(2);
    results(i,3)=x(3);
end
results;
fbz=(2*wap+7*B*wcp)./(2*wA+2*wap+7*B*wcp);
fbx=1+2*results(:,1)/(a/(3^0.5));
fax=1+2*results(:,2)/a;

factor=cat(2,fbz,fbx,fax);
dlmwrite('f-Factor.dat',factor,'delimiter','\t','precision','%.20e');

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



