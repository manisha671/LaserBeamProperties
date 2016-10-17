%T7015T Modelling Exercise Alpha1 - Keyhole;  solution file ready to run

%Material properties (USE YOUR MATERIAL)
Ta=293; A=0.5; 
%Material 1, stainless steel
Tm = 1730; Tv = 2750; K=24; kappa=7.6*10^(-6); rho=6430; cp=490;
%Material 2, aluminium alloy
%Tm = 933; Tv = 2793; K=125; kappa=5.63*10^(-5); rho=2075; cp=1080;
clear xf1 xr1 z1;

%constant parameters
D=5e-3; lambda=1070*10^(-9); PL=7000; d=3e-3;

%cases (CHANGE VALUES HERE)
f=200e-3; v=5/60; 
%High Quality beam:
%M=1,0;
%Low quality beam:
M=2.0; 

% THE CALCULATION OF THE BEAM PROPERTIES IS MISSING - PLEASE ADD
rf0=(2*lambda*f*M)/(D*pi);
I00=(2*PL)/(rf0^2*pi);
zr=2*rf0*(f/D);

c1=(Tv-Ta)*rho*cp*v/2;
fprintf(1,'\nBeam spot radius rf0: %4.0f [microns]\n',rf0*1e6);

%calculation start geometry at the workpiece top
xf=1e-5; xr=1;
s=1.5;
while ((xr>0)|(s>1))
    I=I00*exp(-2*(xf/rf0)^2);
    qf=A*I*tan(pi/3);
    c2=qf/c1-2; c2 = c2^(-10/7); 
    rkh=c2*2*kappa/v;
    qr=c1*(v*rkh/2/kappa)^(-0.7);
    xr=xf-2*rkh;
    I=I00*exp(-2*(xr/rf0)^2);
    c4=A*I*tan(pi/3);
    s=c4/qr;
    xf=xf+1e-8;
end;
%fprintf(1,'xf/r/xr %4.0f %4.0f %4.0f    I q I/q  %3.2e %3.2e %3.2e\n',xf*1e6,rkh*1e6,xr*1e6,c4,qr,s);
fprintf(1,'Keyhole start radius: %4.0f Start locations front: %4.0f  rear: %4.0f [microns]\n',rkh*1e6,xf*1e6,xr*1e6);

%calculation keyhole shape
dz=1e-5; z=dz; i=1;
thf=pi/3; thr=pi/3; 
while ((rkh>1e-6)&(z<d))
    xf=xf-dz*tan(thf); xr=xr+dz*tan(thr);
    rkh=xf-xr;
    
% THE POWER DENSITY FROM THE LASER BEAM IS MISSING FOR THE ENERGY BALANCE - PLEASE ADD
rfz=rf0*sqrt(1+(z/zr));
If=((2*PL)/(rfz^2*pi))*exp(-2*(xf/rfz)^2);
Ir=((2*PL)/(rfz^2*pi))*exp(-2*(xr/rfz)^2);

    c6=(rkh*v/2/kappa)^(-0.7);
    qf=c1*(2+c6); qr=c1*c6;
    thf=atan(qf/A/If); thr=atan(qr/A/Ir);
%    fprintf(1,'z %4.0f  xf %4.0f  xr %4.0f\n',z*1e6,xf*1e6,xr*1e6);
    z1(i)=-z*1e3; xf1(i)=xf*1e3; xr1(i)=xr*1e3; %array loading
    if (rkh<1e-6)
        xf1(i)=0; xr1(i)=0;
    end
    z = z+dz; 
    i=i+1;
end;
fprintf(1,'Bottom: z %4.0f  xf %4.0f  xr %4.0f  rkh %4.0f\n',z*1e6,xf*1e6,xr*1e6,rkh*1e6);

hold all; %'hold all' for multiple curves or 'hold off' for a single graph
plot(xf1,z1,'red',xr1,z1,'red');
hold all;