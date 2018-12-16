function [ sonic_amplitudes ] = define_validation_amps( input_wind )

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



%This function defines the wind forcing according to field data to test how the tree responds.
%It is fixed an inflexible, but could be altered since it is basically just  time-series.

    t=input_wind(:,1);
    x_component=input_wind(:,2);
    y_component=input_wind(:,3);
    x_component(isnan(x_component)==1)=0;
    y_component(isnan(y_component)==1)=0;
    x_amplitude=sprintf(['*Amplitude, name=Xwind']);
    for n=1:length(t)  %this puts it in abaqus format
        amp1=sprintf([num2str(t(n)) ',' num2str(x_component(n))]);
        x_amplitude=strvcat(x_amplitude,amp1);
    end
    y_amplitude=sprintf(['*Amplitude, name=Ywind']);
    for n=1:length(t)  %this puts it in abaqus format
        amp1=sprintf([num2str(t(n)) ',' num2str(y_component(n))]);
        y_amplitude=strvcat(y_amplitude,amp1);
    end
    sonic_amplitudes=strvcat(x_amplitude,y_amplitude);

end

