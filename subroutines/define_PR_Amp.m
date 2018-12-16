function [ CWS_Amp ] = define_PR_Amp( t,windy_sample )

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




%This function defines an artificial wind ramp to test how the tree
%responds and predict the resonant frequency, critical wind speed at
%breaking point etc. It is fixed an inflexible, but could be altered since
%it is basically just a manually created time-series.
         
    %Preset increasing wind.
    %5s ramp and then 35s at each level
    %5 10 10-dynamic 15 20 25
    %60s to sway p&r
    
    %mean_windy=mean(windy_sample);
    t=0:0.1:60;
    ramp_5s=0:0.2:10;
    for n=1:50 
        MCW_wind(n)=ramp_5s(n);
    end
    for n=51:600 %first steady 5m/s
        MCW_wind(n)=0;
    end

    
    CWS_Amp=sprintf(['*Amplitude, name=PR_Amp']);
    for n=1:600   %this puts it in abaqus format
        amp1=sprintf([num2str(t(n)) ',' num2str(MCW_wind(n))]);
        CWS_Amp=strvcat(CWS_Amp,amp1);
    end
    
end

