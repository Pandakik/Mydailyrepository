%%  Computational Methods for Electromagnetic Inverse Scattering 
%%  Chapter 6 Reconstructing Dielectric Scatters
%{
 The code contains both the forward problem solver and Gs-SOM inverse problem solver.
%}

% Copyright � 2018,  National University of Singapore, Tiantian Yin

%% Forward Problem used to calculate the scattered field of scatterer
tic
Chap6_Gs_SOM_forward;
toc
%%  Initialization Scheme used to obtain a initial reconstrution of the domain of interests (DOI)

Chap6_Backpropogation;

%% Inverse Problem used to recontruct the contrast of the DOI

Chap6_Gs_SOM_inverse;
