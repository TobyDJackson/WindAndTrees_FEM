function [ materials_contact_boundary ] = define_materials_contact_boundary( Density,Elasticity,alpha_Rayleigh,beta_Rayleigh,composite,structural,CONTACT_ON , ROOTS)

% Author        Toby Jackson
% Created       14 Jan 2016
%
% This file is part of QSM_to_AbaqusInput.
% 
% QSM_to_AbaqusInput is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation.
% 
% QSM_to_AbaqusInput is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with QSM_to_AbaqusInput.  If not, see <http://www.gnu.org/licenses/>.




%This function defines the material properties, contact condition and
%boundary conditions for abaqus analysis of trees using QSMs. 
%The inputs are the relevant material properties - the structure and output
%of the code is fixed.
%The contact condition can be switched on or off - contact between
%branches is automatically calculated using the abaqus default formulation.
%
%The boundary condition is fixed - 
%and the bottom node in the model is clamped to the ground. This can be
%relaxed to a spring connector with a user define elasticity, if any
%information on the springiness of the root system is available.
 
material_prop=sprintf(['** MATERIALS\n'...
    '**\n'... 
    '*Material, name=wood\n'...
    '*Damping, alpha=' num2str(alpha_Rayleigh) ', beta=' num2str(beta_Rayleigh) ', composite=' num2str(composite) ', structural=' num2str(structural) '\n'... %This refers to Rayleigh mass damping, stiffness damping, composit and structural
    '*Density\n'...
    '' num2str(Density) ',\n'...  %Density in kg/m3
    '*Elastic\n'...
    '' num2str(Elasticity) ', 0.38']);

    if CONTACT_ON==1
        contact=sprintf(['*Surface Interaction, name=Contact1\n'...
        '1.,\n'...
        '*Contact\n'...
        '*Contact Inclusions, ALL EXTERIOR\n'...
        '*Contact Property Assignment\n'...
        ' ,  , Contact1']); %Youngs modulus (Pa) and poissons ratio
    else
        contact='**';
    end
    
   
    boundary=sprintf(['*Boundary\n'...       
        '1,ENCASTRE\n'...
        '*Boundary']);   
     if ROOTS==1
         boundary=sprintf(['**No ENCASTRE boundary because we have a root model'])   ;
     end       
    clearvars new
    
    materials_contact_boundary=strvcat(material_prop,contact,boundary);

end

