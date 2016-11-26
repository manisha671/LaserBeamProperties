%Weld resolidification path

% MATERIAL properties 
Ta=293; Tm = 1730; K=24; kappa=7.6*10^(-6); A=0.1;
fprintf(1,'NEW RUN!!\n');

%PARAMETERS
v=1/60; PL = 200;

dx=1e-5; dy=1e-5; dxf=1e-6; % resolution

xr=0; xf=0; yi=0; xs=0; ymax=5e-3; %if exceeding the border, increase calculation domain ymax

%routine for plotting the xy-pool shape
i=1; nofront = 0; y = 0.0; up = 1; upold = 1;
while ((y < ymax) && (nofront == 0))
    %shape of melt pool in front of laser/keyhole
    T = Tm*2; x0 = dxf; x = x0; j=1; T0 = Tm*3; nofront = 0; 
    while ( (((T0>Tm)&(T>Tm)) | ((T0<Tm)&(T<Tm))) && ((j < 5) | (nofront == 0)))
    
        r=sqrt(x^2+y^2);
        Told = T; xold = x; 
        T=Ta+2*A*PL/K/r*exp(-v*(x+r)/2/kappa);

        if (j==1) T0=T; end; 
        if (T0>Tm) x=x+dxf; else x = x-dxf; end; if (j==1) x = x-2*x0; end;
        if (((T-Told)*(x-xold)) > 0) nofront = 1; else nofront = 0; end;
%    if (T0<Tm) fprintf(1,'*z/x %4.2f/%4.3f   T %4.0f\n',y*1e3,x*1e3,T); end;
        j = j+1;
    end
    fprintf(1,'y/x %4.2f/%4.2f   T %4.0f   %d\n',y*1e3,x*1e3,T,nofront); 
    xf(i)=x;

%  shape of melt pool behind laser/keyhole = resolidification front
    T = Tm*2; Tnew=2; Told=1;
    x=x-dx;
    while ((T>Tm)|(Tnew>Told))
        r=sqrt(x^2+y^2);
        T=Ta+2*A*PL/K/r*exp(-v*(x+r)/2/kappa);
        Told=Tnew; Tnew=T;
        x=x-dx;
    end


    xr(i)=x;
%    fprintf(1,'%3.0d %3.0d  y/x %4.2f/%4.2f   T %4.0f      xf %4.2f  xr %4.2f    dTxy %4.3f %4.3f\n',i,j,y*1e3,x*1e3,T,xf(i),xr(i),dTx,dTy); 
    yi(i)=-y;
    i=i+1; y = y+dy;
end

hold off; 
plot(xr,yi,xf,yi); 
hold all;