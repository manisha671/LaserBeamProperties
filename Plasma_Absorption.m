%PLASMA ABSORPTION

% constants
kb=1.38*10^(-23); hs=1.054*10^(-34); h=hs*2*pi; e=1.602*10^(-19);
me=9.109*10^(-31); c0=2.997*10^8; ce=0.5772;
eps0=8.854*10^(-12);
pa=10^5;

c1=2*pi*me*kb; c1 = c1^1.5; c1 = c1/h/h/h;
d1=e^6/6/sqrt(3)/hs/me/me/c0/eps0^3*sqrt(me/2/pi/kb)*sqrt(3)/pi;
d3=kb/hs*4*exp(-ce);
aib=0;

fprintf(1,'c1 %3.2e    diff %3.2e\n',c1,c1/(2.409*10^21));

clear T1 ni1 aib1; 

%mat data - activate the one you use
%Wi=7.9*e; Z=26; %Fe
%Wi=7.6*e; Z=28; %Ni
%Wi=6.8*e; Z=24; %Cr
%Wi=11.3*e; Z=6; %C
Wi=15.8*e; Z=18; %Ar
%Wi=24.6*e; Z=2; %He
%Wi=13.6*e; Z=8; %O
%Wi=14.5*e; Z=7; %N

lambda=10.6*10^-6; %CO2-laser
%lambda=1.070*10^-6; %Fibre-laser
wL=c0/lambda*2*pi;

i=0;
for T=1000:100:40000
    i=i+1;
    n0=pa/kb/T;
    c2=exp(-Wi/kb/T);
    c3=T^1.5;
    c4=c1*c2*c3;
    p=c4; q=-n0*c4;
    ni=-p/2+sqrt(p*p/4-q); nn=n0-ni; ionperc=ni/n0; 


    T1(i)=T; ion(i)=ionperc; ni1(i)=ni; aib1(i)=aib;
    fprintf(1,'T %4.0f   ni %3.2e   ioniz %3.0f [prc]   aib %3.2f [1/cm]  A %3.2f [prc]\n',T,ni,ionperc*100,ion/100,(1-exp(-aib*10^-3))*100);
end

%outpt plot - activate the one you choose 
% for plotting two curves: plot(T1,ni1,T1,ni2);
hold off; %or: 'hold all' for multiple curves or 'hold off' for a single graph

plot(T1,ni1); 
%plot(T1,aib1);

hold all;
