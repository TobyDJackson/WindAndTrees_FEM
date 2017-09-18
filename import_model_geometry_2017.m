function [ part output_set] = import_model_geometry_2017( cylinder_data,beam_type,output_set_beams, dashpot_coeff ,FIX_DBH,DBH)

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



%This is the most important of the subsections that convert a QSM into an
%abaqus usable input file. It imports the model geometry in Pasi's QSM
%format and ouutputs it in a way that abaqus understands. The user only
%needs to select a beam type - which defines how abaqus solves stresses and
%strains along the beam - the default is B31.

    num_cyls=length(cylinder_data);
    radius=cylinder_data(:,1);
    if FIX_DBH==1
        radius(1)=DBH;
    end
    cyl_length=cylinder_data(:,2);
    cylinder_data(:,5)=cylinder_data(:,5)-cylinder_data(1,5);
    cylinder_data(:,4)=cylinder_data(:,4)-cylinder_data(1,4);
    cylinder_data(:,3)=cylinder_data(:,3)-cylinder_data(1,3);
    new_qsm=zeros(num_cyls,15);
    new_qsm(:,1)=1:num_cyls;new_qsm(:,2:15)=cylinder_data(:,1:14); %this puts an index in before the QSM
    %Setup ABAQUS headers
    node_header=sprintf(['*Heading\n' ...
    'Trees in big new simulation\n'...
    '** PARTS\n'...
    '**\n'...
    '*Part, name=QSM_TREE\n'...
    '*Node']);
    node_list=sprintf([num2str(new_qsm(1,1)) ',' num2str(new_qsm(1,4)) ','...
    num2str(new_qsm(1,5)) ',' num2str(new_qsm(1,6))]); %this defines the first line of the nodes list
    element_header=sprintf(strcat('*Element, type=', beam_type));
    element_list='2,1,2';
    sets='**start of the sections';
    beams='**start of the beams';
   
    for index=2:num_cyls-1; %Loop over number of cylinders
        %Nodes and Elements
        node=sprintf([num2str(new_qsm(index,1)) ',' num2str(new_qsm(index,4)) ','...
        num2str(new_qsm(index,5)) ',' num2str(new_qsm(index,6))]);  %this defines the rest of the nodes list
        node_list=strvcat(node_list,node); %This builds it up
        element=sprintf([num2str(new_qsm(index,1)) ',' num2str(new_qsm(index,10)) ',' ...
        num2str(new_qsm(index,1))]);
        element_list=strvcat(element_list,element);
        %Sets and Beams
        set=sprintf(['*Elset, elset=set' num2str(index) '\n' ...
            num2str(index) ',']);
        sets=strvcat(sets,set);
        beam=sprintf(['*Beam Section, elset=set' num2str(index) ',material=wood,section=circ\n'...
            num2str(radius(index)) '\n'...
              '' num2str(new_qsm(index,9)) ',' num2str(new_qsm(index,7)) ',' num2str(new_qsm(index,8)) '']);
        beams=strvcat(beams,beam);    
    end %End loop over all cylinders for reading into beam geometry
    
     set_5=sprintf(['*Elset, elset=set_5, GENERATE\n'...
    '2,6,1']);
    set_30=sprintf(['*Elset, elset=set_30, GENERATE\n'...
    '2,31,1']); %
    set_150=sprintf(['*Elset, elset=set_150, GENERATE\n'...
    '2,151,1']); %
    set_ELALL=sprintf(['*Elset, elset=ELALL, GENERATE\n'...
    '2,' num2str(num_cyls-1) ',1']) ;%This set contains all the beams for gravity
    
    temp=strsplit(num2str(output_set_beams));
    temp2=temp(1);
    for i=2:length(temp)
        temp2=strcat(temp2,',',temp(i) );
    end
    set_output_set=strvcat('*Elset, elset=output_set',char(temp2));
    
    dashpot=sprintf(['*Dashpot, elset=Springs/Dashpots-1-dashpot\n'...
    '4\n'...
    '' num2str(dashpot_coeff) '\n'...
    '*Element, type=Dashpot1, elset=Springs/Dashpots-1-dashpot\n'...
    '' num2str(size(new_qsm,1)+1) ', 1']);

    %Combine the above
    sets_beams=strvcat(sets,set_ELALL,set_150,set_30,set_5,set_output_set,beams);
    clearvars sets set_ELALL set_30 beams
    end_of_part=sprintf(['*End part']);
    
    nodes=strvcat(node_header,node_list);
    elements=strvcat(element_header,element_list);
    part=strvcat(nodes, elements, sets_beams, dashpot, end_of_part);
    

end

