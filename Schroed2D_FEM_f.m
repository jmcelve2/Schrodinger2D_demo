function[E,psi]=Schroed2D_FEM_f(x,y,V0,Mass,n)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Constants %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

h=6.62606896E-34;               %% Planck constant [J.s]
hbar=h/(2*pi);
e=1.602176487E-19;              %% electron charge [C]
me=9.10938188E-31;              %% electron mass [kg]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Nx=length(x);
Ny=length(y);

dx=x(2)-x(1);
dy=y(2)-y(1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% Building of the operators %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Second derivative X %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DX2(Ny=5,Nx=4); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                                  %
%  -2   0   0   0   0 | 1   0   0   0   0 | 0   0   0   0   0 | 0   0   0   0   0  %
%   0  -2   0   0   0 | 0   1   0   0   0 | 0   0   0   0   0 | 0   0   0   0   0  %
%   0   0  -2   0   0 | 0   0   1   0   0 | 0   0   0   0   0 | 0   0   0   0   0  %
%   0   0   0  -2   0 | 0   0   0   1   0 | 0   0   0   0   0 | 0   0   0   0   0  %
%   0   0   0   0  -2 | 0   0   0   0   1 | 0   0   0   0   0 | 0   0   0   0   0  %
%   -----------------------------------------------------------------------------  %
%   1   0   0   0   0 |-2   0   0   0   0 | 1   0   0   0   0 | 0   0   0   0   0  %
%   0   1   0   0   0 | 0  -2   0   0   0 | 0   1   0   0   0 | 0   0   0   0   0  %
%   0   0   1   0   0 | 0   0  -2   0   0 | 0   0   1   0   0 | 0   0   0   0   0  %
%   0   0   0   1   0 | 0   0   0  -2   0 | 0   0   0   1   0 | 0   0   0   0   0  %
%   0   0   0   0   1 | 0   0   0   0  -2 | 0   0   0   0   1 | 0   0   0   0   0  %
%   -----------------------------------------------------------------------------  %
%   0   0   0   0   0 | 1   0   0   0   0 |-2   0   0   0   0 | 1   0   0   0   0  %
%   0   0   0   0   0 | 0   1   0   0   0 | 0  -2   0   0   0 | 0   1   0   0   0  %
%   0   0   0   0   0 | 0   0   1   0   0 | 0   0  -2   0   0 | 0   0   1   0   0  %
%   0   0   0   0   0 | 0   0   0   1   0 | 0   0   0  -2   0 | 0   0   0   1   0  %
%   0   0   0   0   0 | 0   0   0   0   1 | 0   0   0   0  -2 | 0   0   0   0   1  %
%   -----------------------------------------------------------------------------  %
%   0   0   0   0   0 | 0   0   0   0   0 | 1   0   0   0   0 |-2   0   0   0   0  %
%   0   0   0   0   0 | 0   0   0   0   0 | 0   1   0   0   0 | 0  -2   0   0   0  %
%   0   0   0   0   0 | 0   0   0   0   0 | 0   0   1   0   0 | 0   0  -2   0   0  %
%   0   0   0   0   0 | 0   0   0   0   0 | 0   0   0   1   0 | 0   0   0  -2   0  %
%   0   0   0   0   0 | 0   0   0   0   0 | 0   0   0   0   1 | 0   0   0   0  -2  %
%                                                                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Axy=repmat(ones(1,Nx-1),Ny,1);
Axy=Axy(:);

DX2 = -2*diag(ones(1,Ny*Nx)) + (1)*diag(Axy,-Ny) + (1)*diag(Axy,Ny);
DX2=DX2/dx^2;

%%%%%%%%%%%%%%%%%%%%%%%%%%% Second derivative Y %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DY2(Ny=5,Nx=4); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                                  %
%  -2   1   0   0   0 | 0   0   0   0   0 | 0   0   0   0   0 | 0   0   0   0   0  %
%   1  -2   1   0   0 | 0   0   0   0   0 | 0   0   0   0   0 | 0   0   0   0   0  %
%   0   1  -2   1   0 | 0   0   0   0   0 | 0   0   0   0   0 | 0   0   0   0   0  %
%   0   0   1  -2   1 | 0   0   0   0   0 | 0   0   0   0   0 | 0   0   0   0   0  %
%   0   0   0   1  -2 | 0   0   0   0   0 | 0   0   0   0   0 | 0   0   0   0   0  %
%   -----------------------------------------------------------------------------  %
%   0   0   0   0   0 |-2   1   0   0   0 | 0   0   0   0   0 | 0   0   0   0   0  %
%   0   0   0   0   0 | 1  -2   1   0   0 | 0   0   0   0   0 | 0   0   0   0   0  %
%   0   0   0   0   0 | 0   1  -2   1   0 | 0   0   0   0   0 | 0   0   0   0   0  %
%   0   0   0   0   0 | 0   0   1  -2   1 | 0   0   0   0   0 | 0   0   0   0   0  %
%   0   0   0   0   0 | 0   0   0   1  -2 | 0   0   0   0   0 | 0   0   0   0   0  %
%   -----------------------------------------------------------------------------  %
%   0   0   0   0   0 | 0   0   0   0   0 |-2   1   0   0   0 | 0   0   0   0   0  %
%   0   0   0   0   0 | 0   0   0   0   0 | 1  -2   1   0   0 | 0   0   0   0   0  %
%   0   0   0   0   0 | 0   0   0   0   0 | 0   1  -2   1   0 | 0   0   0   0   0  %
%   0   0   0   0   0 | 0   0   0   0   0 | 0   0   1  -2   1 | 0   0   0   0   0  %
%   0   0   0   0   0 | 0   0   0   0   0 | 0   0   0   1  -2 | 0   0   0   0   0  %
%   -----------------------------------------------------------------------------  %
%   0   0   0   0   0 | 0   0   0   0   0 | 0   0   0   0   0 |-2   1   0   0   0  %
%   0   0   0   0   0 | 0   0   0   0   0 | 0   0   0   0   0 | 1  -2   1   0   0  %
%   0   0   0   0   0 | 0   0   0   0   0 | 0   0   0   0   0 | 0   1  -2   1   0  %
%   0   0   0   0   0 | 0   0   0   0   0 | 0   0   0   0   0 | 0   0   1  -2   1  %
%   0   0   0   0   0 | 0   0   0   0   0 | 0   0   0   0   0 | 0   0   0   1  -2  %
%                                                                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DY22 =(-2)*diag(ones(1,Ny)) + (1)*diag(ones(1,Ny-1),-1) + (1)*diag(ones(1,Ny-1),1);
DY2=[];
for i=1:length(x)
    DY2=blkdiag(DY2,DY22);
end

DY2=DY2/dy^2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% Building of the Hamiltonien %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

H=(-hbar^2/(2*me*Mass)) * ( DX2 + DY2 ) +  diag(V0(:)*e) ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% Diagonalisation of the Hamiltonien %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

H=sparse(H);
[PSI,Energy] = eigs(H,n,'SM');
E = diag(Energy)/e;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% Normalization of the Wavefunction %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:n
    psi_temp=reshape(PSI(:,i),Ny,Nx);
    psi(:,:,i) = psi_temp / sqrt( trapz( y' , trapz(x,abs(psi_temp).^2 ,2) , 1 )  );  % normalisation of the wave function psi
end

psi=psi(:,:,end:-1:1);
E=E(end:-1:1);

end
