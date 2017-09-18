%% 1. Import QSM(s) - these should be simplified, with long cylinders and without disconnects.
cylname='cyl_data_Tf3_LeafOff_Validation_1_2.mat';
load(cylname)
cylinder_data=CylData_updated;
  
%% 2. Choose steps to include (these could be tick-boxes in a GUI)
% to import geometry only use triggers [0 0 0 0 0 1 1 0 0 0 0]
% to run simple grav and freq analysis use triggers [1 1 0 0 0 1 1 0 0 0 0]

EXTRACT_FREQUENCIES=1;   
GRAVITY_ON=1; 
WIND_INPUT=1; %Switch this on if you intend to input your own wind forcing
VARIABLE_ELASTICITY=0; %Reduce the elasticity with height? This follows Sellier et al 2006 - but is not well defined, so best leave it at 0.
MATERIALS_ON=0; %This is to lookup materials from a table for batch processing 
CONTACT_ON=1; %Technically this should always be left on, but the model is insensitive.
ADD_ROOTS=1;
AQUA_ON=0; %This will not work with the free version of abaqus
FIX_DBHS=0; %Overwrite the base cylinder diameter with a field measurement?
CWS=1; %This is a specific wind ramp defined in the subsection 'define_CWS_Amp'
PARAMETERIZE_LEAVES=0;% Add leaves ?

beam_type='B31';  %B33H is the other likely option - it doesn't make much difference.
set='output_set';
output_set_beams=[2 3 4 5 6]; %These are the default output beams
DBH=0.655;
add_leaves=[2 1];

%% 3. Material properties - needed for even the basic analysis
Density=800; Elasticity=7e9; %These defaults get over-written if materials == 1
%Root elasticity and damping
DoF4_Elasticity = 5e6; 
DoF6_Elasticity = DoF4_Elasticity; 
dashpot_coeff=10;
%Damping parameters
alpha_Rayleigh=0.2; beta_Rayleigh=0.001; %These are respectively the mass and stiffness proportional Rayleigh damping coefficients
composite=0; % Don't use this! It is just an estimating way of defining it for composite materials. %This comes up in the frequency extraction
structural=0; %This is ignored! It is the imaginary stiffness proportional damping coefficient.

%% 4. Wind data input - can be deleted if unwanted
% Fluid forcing parameters - needed for any wind forcing
drag_coefficient=0.82; %0.82 is the value used for a long cylinder at high Reynolds number (turbulent flow)
ref_height=15; %Height at which wind speed was measured.
wind_decay=0.05; %0.05 is a good value for winter wind profile judging from field data

t=0:0.1:300;t=t'; %Wind data should be defined at 10hz
load('Sonic_data_5min.mat') %specific to my analysis - example data supplied. You can substitute your own data here.
x_component=Sonic_data_5min(:,10); y_component=Sonic_data_5min(:,11); % These are flowing west and south, respectively. 
%The wind components should be alligned to the x and y directions in the original QSM
input_wind=cat(2,t,x_component,y_component); %USERS NEED TO INPUT THIS ONLY - 10Hz and abaqus global coordinate system


%% 5. THIS IS THE IMPORTANT PART
output_file_extension=['_TEST.inp']; %CHANGE THIS TO REFLECT CHANGES

parameters=struct('alpha_Rayleigh',alpha_Rayleigh,'beta_Rayleigh',beta_Rayleigh,'composite',composite, 'add_leaves',add_leaves,'dashpot_coeff',dashpot_coeff,...
    'drag_coefficient',drag_coefficient,'DoF4_Elasticity',DoF4_Elasticity,'DoF6_Elasticity',DoF6_Elasticity,'DBH',DBH, 'wind_decay',wind_decay,...
    'ref_height',ref_height,'Density',Density, 'Elasticity',Elasticity);

TRIGGERS=struct('PARAMETERIZE_LEAVES',PARAMETERIZE_LEAVES,'ADD_ROOTS',ADD_ROOTS,'AQUA_ON',AQUA_ON,'CONTACT_ON',CONTACT_ON, 'CWS',CWS, 'FIX_DBHS',FIX_DBHS,...
    'GRAVITY_ON',GRAVITY_ON,'MATERIALS_ON',MATERIALS_ON,'VARIABLE_ELASTICITY',VARIABLE_ELASTICITY,'WIND_INPUT',WIND_INPUT, 'EXTRACT_FREQUENCIES',EXTRACT_FREQUENCIES);

[ abaqus_tree] = Convert_Q2A_full( cylinder_data,TRIGGERS,parameters,input_wind,output_set_beams,beam_type, output_file_extension);
    
%% 6. Save the file
full_input_file=mat2clip(abaqus_tree);
filenam=cylname;
filenam(find(filenam=='.',1,'last'):end) = [];
filenam(1:find(filenam=='\',1,'last')) = [];
savename=strcat(filenam,output_file_extension);
fid=fopen(savename,'w');
fprintf(fid,full_input_file);
fclose(fid);

