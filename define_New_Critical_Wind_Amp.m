function [ MCW_Amp ] = define_New_Critical_Wind_Amp( t,windy_sample )

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
    
    mean_windy=mean(windy_sample);
    ramp_5s=0:0.1:5;
    for n=1:50 
        MCW_wind(n)=ramp_5s(n);
    end
    for n=51:400 %first steady 5m/s
        MCW_wind(n)=5;
    end
    for n=401:450 
        MCW_wind(n)=ramp_5s(n-400)+5;
    end
    for n=451:800 %second steady 10 m/s
        MCW_wind(n)=10;
    end
    for n=801:850 
        MCW_wind(n)=ramp_5s(n-800)+10; 
    end
    for n=851:1200 %third steady 15 m/s
        MCW_wind(n)=15;
    end
    for n=1201:1250 
        MCW_wind(n)=ramp_5s(n-1200)+15; 
    end
    for n=1251:1600 %fourth steady 20 m/s
        MCW_wind(n)=20;
    end
    for n=1601:1650
        MCW_wind(n)=ramp_5s(n-1600)+20; 
    end
    for n=1651:2000 %fifth steady 25m/s
        MCW_wind(n)=25;
    end
    
    for n=2001:3000 %minute of 0
        MCW_wind(n)=0;
    end
    
    for n=3001:3050 
        MCW_wind(n)=ramp_5s(n-3000);
    end
    for n=3051:3400 %first steady 5m/s
        MCW_wind(n)=windy_sample(n-3050)+5-max(windy_sample);
    end
    for n=3401:3450 
        MCW_wind(n)=ramp_5s(n-3400)+5;
    end
    for n=3451:3800 %second steady 10 m/s
        MCW_wind(n)=windy_sample(n-3450)+10-max(windy_sample);
    end
    for n=3801:3850 
        MCW_wind(n)=ramp_5s(n-3800)+10; 
    end
    for n=3851:4200 %third steady 15 m/s
        MCW_wind(n)=windy_sample(n-3850)+15-max(windy_sample);
    end
    for n=4201:4250 
        MCW_wind(n)=ramp_5s(n-4200)+15; 
    end
    for n=4251:4600 %fourth steady 20 m/s
        MCW_wind(n)=windy_sample(n-4250)+20-max(windy_sample);
    end
    for n=4601:4650
        MCW_wind(n)=ramp_5s(n-4600)+20; 
    end
    for n=4651:5000 %fifth steady 25m/s
        MCW_wind(n)=windy_sample(n-4650)+25-max(windy_sample);
    end
    
            
    %MCW_wind=MCW_wind./abs_x;
    
    MCW_Amp=sprintf(['*Amplitude, name=MCW_Amp']);
    for n=1:5000   %this puts it in abaqus format
        amp1=sprintf([num2str(t(n)) ',' num2str(MCW_wind(n))]);
        MCW_Amp=strvcat(MCW_Amp,amp1);
    end
    
end

