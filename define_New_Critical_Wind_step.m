function [ MCW_step ] = define_New_Critical_Wind_step( cylinder_data,leaf,drag_coefficient,set, ADD_ROOTS )

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



%This function defines the step instruction that applies the critical wind amp to the
%tree. The output is a piece of text in input file format. The relevant
%drag coefficient and the set of beams the user wants to obtain output data
%for can be defined here.It also multiples the cylinder diameter by a
%given leaf parameterization input that is defined in
%'parameterize_leaves.m'

    radius=cylinder_data(:,1);
    num_cyls=length(cylinder_data);
    
    MCW_header=sprintf(['** STEP: MCW_Wind\n'... 
    '*Step, name=MCW_Wind, NLGEOM=YES, UNSYMM=YES, INC=50000\n'...
    '**DRAG LOADS\n'...
    '*DYNAMIC\n'...
    '0.1,500, 1e-11, 0.25']);%\n'...
    %'*DLOAD\n'...  %THIS ADDS GRAVITY
    %'ELALL, GRAV, 9.8, 0.0, 0.0, -1.0,']);
    
    MCW_dloads='*DLOAD';
    for index=2:num_cyls-1
       MCW_load=sprintf(['set' num2str(index) ', WDD, 1,' num2str(2*radius(index)*leaf(index)) ',' num2str(drag_coefficient) ',1,MCW_Amp']);
       %This is WDD, magnitude (varied with AMPLITUDE), effective_D, Drag coefficient, cosine of directions etc (default =1),Xamplitude,Yamplitude
       MCW_dloads=strvcat(MCW_dloads,MCW_load);
    end
    
    output_requests=sprintf([strcat('*EL PRINT, ELSET=', set ,', FREQUENCY=1\n')...
    '7,11\n'...
    'E11,\n'...
    '*End Step']);
    
    if ADD_ROOTS==1
            MCW_dloads='*DLOAD';
            for index=2:num_cyls-1
               MCW_load=sprintf(['Assembly1.Instance1.set' num2str(index) ', WDD, 1,' num2str(2*radius(index)*leaf(index)) ',' num2str(drag_coefficient) ',1,MCW_Amp']);
               %This is WDD, magnitude (varied with AMPLITUDE), effective_D, Drag coefficient, cosine of directions etc (default =1),Xamplitude,Yamplitude
               MCW_dloads=strvcat(MCW_dloads,MCW_load);
            end

            output_requests=sprintf([strcat('*EL PRINT, ELSET=Assembly1.Instance1.', set ,', FREQUENCY=1\n')...
            '7,11\n'...
            'E11,\n'...
            '*End Step']);
    end

     MCW_step=strvcat(MCW_header,MCW_dloads,output_requests);


end

