function [ abaqus_tree] = Convert_Q2A_full(cylinder_data,TRIGGERS,parameters,...
        input_wind,output_set_beams,beam_type, file_extension) 

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

    %The function below follows this order:
    %USER INPUT: import QSMs and choose steps / parameters
    %Subroutines:
    %1. Import model geometry
    %2. Material properties, contact and boundary conditions
    %3. Frequency and gravity steps
    %4. Parameterize leaves - optional
    %5. Validation amplitude and step definition
    %6. Combine everything and save input file.

    set='output_set';
    structural=0;

    
    %% ---1. IMPORT MODEL GEOMETRY -------------------------    
    if TRIGGERS.VARIABLE_ELASTICITY==0
        [ part ] = import_model_geometry_2017( cylinder_data ,beam_type,output_set_beams, parameters.dashpot_coeff,TRIGGERS.FIX_DBHS,parameters.DBH);
        [ materials_contact_boundary ] = define_materials_contact_boundary( parameters.Density,parameters.Elasticity,parameters.alpha_Rayleigh,...
            parameters.beta_Rayleigh,parameters.composite,structural,TRIGGERS.CONTACT_ON, TRIGGERS.ADD_ROOTS );
    else
        [ part ] = import_model_geometry_with_variable_E_2017( cylinder_data,beam_type,output_set_beams, parameters.dashpot_coeff ,TRIGGERS.FIX_DBHS,parameters.DBH);
        [ materials_contact_boundary ] = define_materials_with_variable_E_contact_boundary( parameters.Density,parameters.Elasticity,parameters.alpha_Rayleigh,...
            parameters.beta_Rayleigh,parameters.composite,structural,TRIGGERS.CONTACT_ON , TRIGGERS.ADD_ROOTS);
    end
    
    if TRIGGERS.ADD_ROOTS==1  
        [ root_section ] = add_roots( parameters.DoF4_Elasticity, parameters.DoF6_Elasticity  );
        part=strvcat(part,root_section);
    end
    
    
    %% ---3. GRAVITY ON/OFF & FREQUENCY ON/OFF-----------------------------------
    [ frequency_and_gravity_step ] = define_freq_and_grav( TRIGGERS.EXTRACT_FREQUENCIES, TRIGGERS.GRAVITY_ON, TRIGGERS.ADD_ROOTS );
    
    
    %% ---4. PARAMETERIZE LEAVES--------------------------------------------    
    leaf=ones(length(cylinder_data),1); %This multiplies the effective radius of the branches in the DLOAD command
    if TRIGGERS.PARAMETERIZE_LEAVES==1;
        [ leaf ] = paramaterize_leaves( cylinder_data, add_leaves );
    end

     %% 5. AQUA Setup & Validation    
    if TRIGGERS.WIND_INPUT==1
        [ sonic_amplitudes ] = define_validation_amps( input_wind );
        [ validation_step ] = define_validation_step( input_wind, cylinder_data,leaf, parameters.drag_coefficient,set ,TRIGGERS.ADD_ROOTS);
    end
     
    if TRIGGERS.AQUA_ON==1
     setup_aqua=sprintf(['*AQUA\n'...
        '0.0, 0.0, 9.81, 0.0\n'... %Elevation of the seabed, elev of fluid surface, g, mas density of fluid.More lines to do with fluid veolity and waves are possible here.
        '*WIND\n'...
        '1.27,' num2str(parameters.ref_height) ', 1,1, 1, 0,' num2str(parameters.wind_decay) '']);
    else
        setup_aqua='**No Aqua';
    end
   
    if TRIGGERS.CWS==1
        windy_sample=input_wind(1:350,2);
        [ CWS_Amp ] = define_CWS_Amp( input_wind(:,1),windy_sample );
        [ CWS_step ] = define_CWS_Step( cylinder_data,leaf,parameters.drag_coefficient,set, TRIGGERS.ADD_ROOTS );
    else
        [ CWS_Amp ] = '** No CWS';
        [ CWS_step ] = '**No CWS';
    end
         
     %% 6. Combine and save----------------------------------------------
    if TRIGGERS.WIND_INPUT==1
        abaqus_tree=strvcat(part,materials_contact_boundary,sonic_amplitudes,CWS_Amp,setup_aqua, ...
        frequency_and_gravity_step,validation_step,CWS_step); 
    else
        abaqus_tree=strvcat(part,materials_contact_boundary,CWS_Amp,setup_aqua,frequency_and_gravity_step,CWS_step); 
    end
end

