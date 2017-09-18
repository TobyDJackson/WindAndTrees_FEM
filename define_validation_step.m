function [ validation_step ] = define_validation_step( input_wind,cylinder_data,leaf, drag_coefficient, set , ADD_ROOTS)
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




%This function defines the step instruction that applies the MCW amp to the
%tree. The output is a piece of text in input file format. The relevant
%drag coefficient and the set of beams the user wants to obtain output data
%for can be defined here. It also multiples the cylinder diameter by a
%given leaf parameterization input that is defined in
%'parameterize_leaves.m'

    radius=cylinder_data(:,1);
    num_cyls=length(cylinder_data);
    simulation_length=max(input_wind(:,1));
    
    validation_header=sprintf(['** STEP: Validation_Wind\n'... 
    '*Step, name=Validation_Wind, NLGEOM=YES, UNSYMM=YES, INC=5000000\n'...
    '**DRAG LOADS\n'...
    '*DYNAMIC\n'...
    '0.1,' num2str(simulation_length) ', 1e-11, 0.25']);%\n'...
    %'*DLOAD\n'...  %THIS ADDS GRAVITY
    %'ELALL, GRAV, 9.8, 0.0, 0.0, -1.0,']);
    
    validation_dloads='*DLOAD';
    for index=2:num_cyls-1
       validation_load=sprintf(['set' num2str(index) ', WDD, 1,' num2str(2*radius(index)*leaf(index)) ',' num2str(drag_coefficient) ',1,Xwind,Ywind']);
       %This is WDD, magnitude (varied with AMPLITUDE), effective_D, Drag coefficient, cosine of directions etc (default =1),Xamplitude,Yamplitude
       validation_dloads=strvcat(validation_dloads,validation_load);
    end

    output_requests=sprintf([strcat('*EL PRINT, ELSET=', set ,', FREQUENCY=1\n')...
    '7,11\n'...
    'E11,\n'...
    '*End Step']);

    if ADD_ROOTS==1
        validation_dloads='*DLOAD';
        for index=2:num_cyls-1
           validation_load=sprintf(['Assembly1.Instance1.set' num2str(index) ', WDD, 1,' num2str(2*radius(index)*leaf(index)) ',' num2str(drag_coefficient) ',1,Xwind,Ywind']);
           %This is WDD, magnitude (varied with AMPLITUDE), effective_D, Drag coefficient, cosine of directions etc (default =1),Xamplitude,Yamplitude
           validation_dloads=strvcat(validation_dloads,validation_load);
        end
         output_requests=sprintf([strcat('*EL PRINT, ELSET=Assembly1.Instance1.', set ,', FREQUENCY=1\n')...
        '7,11\n'...
        'E11,\n'...
        '*End Step']);
    end

    validation_step=strvcat(validation_header,validation_dloads,output_requests);
end

