function [ frequency_and_gravity_step ] = define_freq_and_grav( FREQUENCY_ON, GRAVITY_ON, ADD_ROOTS )

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




%This function defines the frequency and gravity step for abaqus analysis
%of trees using QSMs. The output is a piece of text in the input file
%format. This code isn't very flexible, you can either apply frequency
%extraction and/or a gravity force and that's it. As a default there is no
%output during the gravity step but plenty of output during the frequency
%step.

   %Gravity step with output suppressed.
    gravity_step=sprintf(['*STEP,name=Gravity,NLGEOM=YES,UNSYMM=YES\n'...
    '*STATIC\n'...
    '1., 5., 5e-11, 1.\n'...
    '*DLOAD\n'...
    'ELALL,GRAV,9.8,0.0,0.0,-1.0,\n'...
    '*End Step']);
    if ADD_ROOTS==1
        gravity_step=sprintf(['*STEP,name=Gravity,NLGEOM=YES,UNSYMM=YES\n'...
        '*STATIC\n'...
        '1., 5., 5e-11, 1.\n'...
        '*DLOAD\n'...
        'Assembly1.Instance1.ELALL,GRAV,9.8,0.0,0.0,-1.0,\n'...
        '*End Step']);
    end

    %Frequency step
    frequency_step=sprintf(['** STEP: Frequency\n'... 
    '*Step, name=Frequency, nlgeom=YES, perturbation\n'...
    '*Frequency, eigensolver=subspace, normalization=displacement\n'...
    '100, , , 38, 30\n'...
    '** OUTPUT REQUESTS\n'...
    '*Restart, write, frequency=0\n'...
    '** FIELD OUTPUT: F-Output-1\n'...
    '*Output, field, variable=PRESELECT\n'...
    '*End Step']);

    if GRAVITY_ON==0 %Overwrite Gravity step
        gravity_step='** NO GRAVITY';
    end
    if FREQUENCY_ON==0
        frequency_step='** NO FREQUENCY';
    end 
    frequency_and_gravity_step=strvcat(gravity_step,frequency_step);  

end

