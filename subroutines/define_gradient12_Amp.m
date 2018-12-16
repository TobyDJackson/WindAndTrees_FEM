function [ CWS_Amp ] = define_gradient12_Amp( t,windy_sample )


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
    ramp_5s=0:0.1:5; ramp_5s=ramp_5s.*2/5;
    for n=1:50;    MCW_wind(n)=ramp_5s(n);    end
    %first steady 2m/s
    for n=51:200 
        MCW_wind(n)=2;
    end
    
    for n=201:250 
        MCW_wind(n)=ramp_5s(n-200)+2;
    end
    for n=251:400 %second steady 4 m/s
        MCW_wind(n)=4;
    end
    
    for n=401:450 
        MCW_wind(n)=ramp_5s(n-400)+4; 
    end
    for n=451:600 %third steady 15 m/s
        MCW_wind(n)=6;
    end
    
    for n=601:650 
        MCW_wind(n)=ramp_5s(n-600)+6; 
    end
    for n=651:800 %fourth steady 20 m/s
        MCW_wind(n)=8;
    end
    
    for n=801:850
        MCW_wind(n)=ramp_5s(n-800)+8; 
    end
    for n=851:1000 %fifth steady 10m/s
        MCW_wind(n)=10;
    end
    
    for n=1001:1050 
        MCW_wind(n)=ramp_5s(n-1000)+10; 
    end
    for n=1051:1200 %sixth steady 12 m/s
        MCW_wind(n)=12;
    end
    
            
    %MCW_wind=MCW_wind./abs_x;
    
    CWS_Amp=sprintf(['*Amplitude, name=CWS_Amp']);
    for n=1:1200   %this puts it in abaqus format
        amp1=sprintf([num2str(t(n)) ',' num2str(MCW_wind(n))]);
        CWS_Amp=strvcat(CWS_Amp,amp1);
    end
    
end

