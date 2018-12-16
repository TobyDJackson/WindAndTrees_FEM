function [ leaf ] = paramaterize_leaves( cylinder_data,add_leaves )

% Author        Toby Jackson
% Created       14 Jan 2016

%This function ouputs a vector the same length as the CylData file which
%defines how much each cylinder diameter should be multiplied by in order to account
%for leaves. This extra area 'feels' the force of wind, but doesn't affect
%the mechanical behaviour of the cylinder (this remains defined by the
%original diameter). This provides a crude way of parameterizing leaves.

%You can only add leaves to the top two branching orders, the input should
%be multipliers in the form [top penultimate].
%The default is no leaves added ([1 1])
%I have found [3 2] works ok for simulating summer conditions.
    leaf=ones(length(cylinder_data),1); 
    num_cyls=length(cylinder_data);
    branch_order=cylinder_data(:,12);
    max_order=max(branch_order);
    twigs=max_order-branch_order; %reverse branch order WHY?
    size_twigs=size(twigs);
    for index=1:size(twigs)  %add leaves on to the highest two branch orders
        if twigs(index) == 0 
            leaf(index,1)=add_leaves(1);
        end
        if twigs(index) == 1
            leaf(index,1)=add_leaves(2);
        end
    end %End loop over twigs
end

