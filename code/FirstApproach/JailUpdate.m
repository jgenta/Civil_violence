function [Agents, Map]=JailUpdate(AgentsOld, MapOld)

%% ----Updates Jail Terms in end of timestep----
% Input:
% -a vector containing all Agents' info
% -the Grid filled with agents and cops
%
% Output:
% -updated vector containing all Agents' info
% -updated grid filled with agents and cops
%
% How it works:
% Check positions in the Map that are free
% For each agent, decrease his jail term if he is in jail
% If he is going to exit from jail (jail term=1), set him to inactive and
% assign him to a random free position in Map
% Update Map matrix accordingly


Agents=AgentsOld;
Map=MapOld;

% Find free places in Map
FreeSlots=find((Map(:,:,1)+Map(:,:,3))==0);
FreeSlots=[mod(FreeSlots,size(Map,2))+(mod(FreeSlots,size(Map,2))==0)*size(Map,2), ceil(FreeSlots/size(Map,2))];

% Shuffle elements in FreeSlots
FreeSlots=FreeSlots(randsample(size(FreeSlots,1),size(FreeSlots,1)),:);

slotInd=1;

% For each Agent
for k=1:size(Agents,1)
    
%   If he is going to exit from jail
    if Agents(k,6)==1
        
%       Put him in a random free place in Map
        Agents(k,1)=FreeSlots(slotInd,1);
        Agents(k,2)=FreeSlots(slotInd,2);
        
%       Set him to inactive
        Agents(k,3)=0;
        
%       Update Map matrix accordingly
        Map(FreeSlots(slotInd,1),FreeSlots(slotInd,2),1)=1;
        Map(FreeSlots(slotInd,1),FreeSlots(slotInd,2),2)=Agents(k,3);
        slotInd=slotInd+1;
        
    end
        
%   Decrease his jail term if he is in jail
    if (Agents(k,6)>0)
        Agents(k,6)=Agents(k,6)-1;
    end

end

		


end