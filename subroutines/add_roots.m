function [ root_section ] = add_roots( DoF4_Elasticity, DoF6_Elasticity  )

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




%This is a tag on section and can be switched on and off. It add's roots
%but in the process it has to slightly change the way things are defined
%within ABAQUS (since I want to attach something to ground my tree model
%has to be just one 'instance' of an overall assembly, which includes the
%ground, so that I can define an external connector). The root model is
%just a U-joint with two angular degrees of freedom that can be assigned
%elasticity.

 root_section=sprintf(['** Define and assembly - necessary for roots. \n' ...
'**\n' ...
'*Assembly, name=Assembly1\n' ...
'**  \n' ...
'*Instance, name=Instance1, part=QSM_TREE\n' ... % Don't change these names!
'*End Instance\n' ...
'**  \n' ...
'*Element, type=CONN3D2\n' ...
'1, Instance1.1, \n' ...
'*Connector Section, elset=Wire-1-Set-1, behavior=ConnSect-1\n' ...
'UJoint,\n' ...
'"Datum csys-2",\n' ...
'*Nset, nset=Wire-1-Set-1, instance=Instance1\n' ...
' 1,\n' ...
'*Elset, elset=Wire-1-Set-1\n' ...
' 1,\n' ...
'*Nset, nset=_M6, internal, instance=Instance1\n' ...
' 1,\n' ...
'*Orientation, name="Datum csys-2"\n' ...
'          1.,           0.,           0.,           0.,           1.,           0.\n' ...
'3, 0.\n' ...
'*End Assembly\n' ...
'*Connector Behavior, name=ConnSect-1\n' ...
'*Connector Elasticity, component=4\n' ...
'' num2str(DoF4_Elasticity) '.,\n' ...
'*Connector Elasticity, component=6\n' ...
'' num2str(DoF6_Elasticity) '.,\n' ...
'** ']);

end

