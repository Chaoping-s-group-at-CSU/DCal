
function D_BCC(x)
global Element impurity path m n p
k=8.617343*10^(-5);
f0=0.7272;%bcc
T=0:10:2800;T=T';t=1000./T;
cd ..
cd(Element);cd('ori');
Thermal=dlmread('ThermoData.dat');Hp=Thermal(:,2);Sp=Thermal(:,3);Gp=Thermal(:,4); %perfect crystal
A=dlmread('CONTCAR','',[2,0,2,0]);
B=dlmread('CONTCAR','',[1,0,1,0]);
a=2*A.*B/m;
atom_perfect = m*n*p;
atom = atom_perfect-1;
cd ..
cd('w0');Thermal=dlmread('ThermoData.dat');Hv=Thermal(:,2);Sv=Thermal(:,3);Gv=Thermal(:,4);
cd ..
copyfile('0To1.dat','0To0.dat');
movefile('0To0.dat',path);%change path !!!
cd ..
cd([Element,'-',impurity])
dGf=Gv-atom*Gp/atom_perfect;Cv=exp(-1*dGf./(T.*k));
cd('w2');Thermal=dlmread('ThermoData.dat');Hiv=Thermal(:,2);Siv=Thermal(:,3);Giv=Thermal(:,4);
cd ..
cd (impurity);Thermal=dlmread('ThermoData.dat');Hi=Thermal(:,2);Si=Thermal(:,3);Gi=Thermal(:,4);
cd ..
dGb=Gi(1)+Gv(1)-Giv(1)-Gp(1);
dGfi=dGf-dGb;%dSfi=dSf-dSb;dHfi=dGfi+dSfi.*T;%concentration of vacancy nn to impurity
Civ=exp(-1*dGfi./(T.*k));%we only use the value at 0K, dGb is a constant.
DrawW([0,0;0,2;0,3;3,0;0,4;3,5]);freq=dlmread('v b w.dat');  %0to0 is w0;0to2 is w2;0to3 is w3;3to0 is w4;0to4 is w3';3to5 is w5
%neb([0,2;0,3;0,4;3,5]);
b0=freq(:,7);b2=freq(:,8);b3=freq(:,9);b4=freq(:,10);b3p=freq(:,11);b5=freq(:,12);
v0=freq(:,1);v2=freq(:,2);v3=freq(:,3);v4=freq(:,4);v3p=freq(:,5);v5=freq(:,6);
w0=freq(:,13);w2=freq(:,14);w3=freq(:,15);w4=freq(:,16);w3p=freq(:,17);w5=freq(:,18);
Ffactor;
fac=dlmread('f-Factor.dat');f=fac(:,6);
% actH=fac(:,8);
Di=f.*w2.*(a*10.^(-10)).^2.*Civ;
% D0=f.*w2.*(a*10.^(-10)).^2.*exp((dSfi.*T+actH)./(k*T));
% Q=dHm+dHfi-actH;
D_self=f0*(a*10.^(-10)).^2.*Cv.*w0;
% out=cat(2,T,t,dGfi,Civ,Cv,f,Di,D_self);
% name={'T','t','dGfi','Civ','Cv','f','Di','D_self'}
ReadDir=x;
T_init=ReadDir(1);
T_end=ReadDir(2);
T_out=T_init:10:T_end;
t_out=1000./T_out;
T_out=T_out';
t_out=t_out';
line1=T_init/10+1;
line2=T_end/10+1;
Di_out=Di(line1:line2);
D_self_out=D_self(line1:line2);
Civ_out=Civ(line1:line2);
Cv_out=Cv(line1:line2);
out=cat(2,T_out,t_out,Di_out,D_self_out,Civ_out,Cv_out);
dlmwrite('D.dat',out,'delimiter','\t','precision','%.20e');
dat=dlmread('D.dat');
x=dat(:,2);
y1=dat(:,3);
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
MQ1 = sprintf('Parameter MQ(BCC&%s,%s;0)  298.15 %s+R*T*ln(%s); 6000 N !', impurity, Element, a1, D0_1);
MQ2 = sprintf('Parameter MQ(BCC&%s,%s;0)  298.15 %s+R*T*ln(%s); 6000 N !', Element, Element, a2, D0_2);
fileID = fopen('MQ_tdb.dat', 'w');
fprintf(fileID, '%s\n', MQ1);
fprintf(fileID, '%s\n', MQ2);
fclose(fileID);

function DrawW(x)
% extract the value of each jump frequency
% x can be DrawW([0,0;1,4;2,4;3,4;4,3])
Readfile=x;
for i=1:6
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
zero=dlmread('0To0.dat');
two=dlmread('0To2.dat');
three=dlmread('0To3.dat');
four=dlmread('3To0.dat');
five=dlmread('3To5.dat');
threep=dlmread('0To4.dat');
zero=zero(:,4);two=two(:,4);three=three(:,4);four=four(:,4);five=five(:,4);threep=threep(:,4);
for i=1:length(zero)
    if (zero(i)==0 || two(i)==0 || three(i)==0 || four(i)==0|| five(i)==0 ||threep(i)==0)
        f(i)=0;
    else
        F(i)=((331.14*(four(i)/five(i))^2+857.93*(four(i)/five(i))+409.95)/(165.57*(four(i)/five(i))+134.2))/7;
        f(i)=(7*threep(i)*F(i))/(2*two(i)+7*threep(i)*F(i));
    end
end
tem=0:10:2800;
tem=tem';
f=f';
% for i=1:length(f)
%     if f(i)==0
%         continue
%     else
%         t=i;
%         break
%     end
% end
% tinv=1./tem;ffit=log(f);
% C=polyfit(tinv(t:end),ffit(t:end),2);
% C=polyder(C);ztemp=zeros(t-1,1);
% cout=polyval(C,tinv(t:end));cout=cat(1,ztemp,cout);cout=cout*8.617343*10^(-5);
factor=cat(2,tem,zero,two,three,four,f);
dlmwrite('f-Factor.dat',factor,'delimiter','\t','precision','%.20e');

