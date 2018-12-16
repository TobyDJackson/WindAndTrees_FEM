function [ CWS_Amp ] = define_CURTAILED_CWS_Amp( t,windy_sample )

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
    t=0:0.1:660;
    ramp_5s=0:0.1:5;
    for n=1:50 
        MCW_wind(n)=ramp_5s(n);
    end
    for n=51:200 %first steady 5m/s
        MCW_wind(n)=5;
    end
    
    for n=201:250 
        MCW_wind(n)=ramp_5s(n-200)+5;
    end
    for n=251:400 %second steady 10 m/s
        MCW_wind(n)=10;
    end
    
    for n=401:450 
        MCW_wind(n)=ramp_5s(n-400)+10; 
    end
    for n=451:600 %third steady 15 m/s
        MCW_wind(n)=15;
    end
    
    for n=601:650 
        MCW_wind(n)=ramp_5s(n-600)+15; 
    end
    for n=651:800 %fourth steady 20 m/s
        MCW_wind(n)=20;
    end
    
    for n=801:850
        MCW_wind(n)=ramp_5s(n-800)+20; 
    end
    for n=851:1000 %fifth steady 25m/s
        MCW_wind(n)=25;
    end
    
    for n=1001:1050 
        MCW_wind(n)=ramp_5s(n-1000)+25; 
    end
    for n=1051:1200 %sixth steady 30 m/s
        MCW_wind(n)=30;
    end
    
    for n=1201:1250
        MCW_wind(n)=ramp_5s(n-1200)+30; 
    end
    for n=1251:1400 %seventh steady 35m/s
        MCW_wind(n)=35;
    end
    
    for n=1401:1450
        MCW_wind(n)=ramp_5s(n-1400)+35; 
    end
    for n=1451:1600 %eighth steady 40m/s
        MCW_wind(n)=40;
    end
    
    for n=1601:1650
        MCW_wind(n)=ramp_5s(n-1600)+40; 
    end
    for n=1651:1800 %ninth steady 45m/s
        MCW_wind(n)=45;
    end
    
    for n=1801:1850
        MCW_wind(n)=ramp_5s(n-1800)+45; 
    end
    for n=1851:2000 %tenth steady 45m/s
        MCW_wind(n)=50;
    end
    
    for n=2001:2050
        MCW_wind(n)=ramp_5s(n-2000)+50; 
    end
    for n=2051:2200 %tenth steady 45m/s
        MCW_wind(n)=55;
    end
    
    for n=2201:2250
        MCW_wind(n)=ramp_5s(n-2200)+55; 
    end
    for n=2251:2400 %tenth steady 45m/s
        MCW_wind(n)=60;
    end
    
    for n=2401:2450
        MCW_wind(n)=ramp_5s(n-2400)+60; 
    end
    for n=2451:2600 %tenth steady 45m/s
        MCW_wind(n)=65;
    end
    
    for n=2601:2650
        MCW_wind(n)=ramp_5s(n-2600)+65; 
    end
    for n=2651:2800 %tenth steady 45m/s
        MCW_wind(n)=70;
    end
            
    %MCW_wind=MCW_wind./abs_x;
    
    CWS_Amp=sprintf(['*Amplitude, name=CWS_Amp']);
    for n=1:2800   %this puts it in abaqus format
        amp1=sprintf([num2str(t(n)) ',' num2str(MCW_wind(n))]);
        CWS_Amp=strvcat(CWS_Amp,amp1);
    end
    
end

