function [Agents, Map]=JailUpdate(AgentsOld, MapOld)

%% ----Updates Jail Terms in end of timestep----
% 
% Improvements to be done:
% 
% 


Agents=AgentsOld;
Map=MapOld;

FreeSlots=find((Map(:,:,1)+Map(:,:,3))==0);                                 %find empty positions on map
FreeSlots=[mod(FreeSlots,size(Map,2))+(mod(FreeSlots,size(Map,2))==0)*size(Map,2), ceil(FreeSlots/size(Map,2))];

FreeSlots=FreeSlots(randsample(size(FreeSlots,1),size(FreeSlots,1)),:);     %Shuffle elements in FreeSlots

slotInd=1;

for i=1:size(FreeSlots,1)                                                   %chick, if slot is really free of cops and agents
   if (Map(FreeSlots(i,1),FreeSlots(i,2),1)+Map(FreeSlots(i,1),FreeSlots(i,2),3))>0
        display('ASSHOLE, you got it all wrong!');
   end
end

for k=1:size(Agents,1)                                                      %go through agents vector
    if Agents(k,6)==1                                                       %check, if jail term reaches 0 after update
        Agents(k,1)=FreeSlots(slotInd,1);                                   %place him on free place
        Agents(k,2)=FreeSlots(slotInd,2);
        Agents(k,3)=1;                                                      %put him back on grid
        Map(FreeSlots(slotInd,1),FreeSlots(slotInd,2),1)=1;
        Map(FreeSlots(slotInd,1),FreeSlots(slotInd,2),2)=1;
        slotInd=slotInd+1;
        
    end
        
    if (Agents(k,6)>0)                                                      %if he is in jail, decrease jail term by 1
        Agents(k,6)=Agents(k,6)-1;
    end

end

		


end