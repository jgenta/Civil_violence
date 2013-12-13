function [Agents, Cops, Map]=decide(AgentsOld, CopsOld, MapOld,K,vp, Thresh)

%% ----Sweeps through agents array and updates their status----
% 
% Improvements to be done:
% Maybe integrate in move function to avoid picking random agents twice
% (but might introduce some artifacts
% Why AgentsOld???



Agents=AgentsOld;
Cops=CopsOld;
Map=MapOld;

%% Random Update:
AgentsToUpdate=Agents(randsample(size(Agents,1),size(Agents,1)),:);       %Shuffle elements in Agents and Cops
	
for k=1:size(AgentsToUpdate,1)                                            %Update them one at a time
    
    if AgentsToUpdate(k,6)==0
    	ActiveAgents=1-Map(AgentsToUpdate(k,1),AgentsToUpdate(k,1),2);        %check all places around for active agents and cops, initialiye ActiveAgents with 1 or 0 depending wether he's active or not:
        NumberCops=0;                                                         %initialize number of cops with 0
        
        for i=max(AgentsToUpdate(k,1)-vp,1):min(AgentsToUpdate(k,1)+vp,size(Map,1))   %which are all the places around him (border control included)
            for j=max(AgentsToUpdate(k,2)-vp,1):min(AgentsToUpdate(k,2)+vp,size(Map,2))
                ActiveAgents=ActiveAgents+Map(i,j,2);                  %increase number of agents by 1 for each agent in reach                                                       
                NumberCops=NumberCops+Map(i,j,3);                           %increase number of cops by 1
            end
        end
        
        P=1-exp(K*(NumberCops/(ActiveAgents)));        %evaluate arrest probability --> k is negative!
        N=AgentsToUpdate(k,5)*P;                     %Net risk=risk aversion * arrest probability: if it's high, I really don't want to turn active
        if (AgentsToUpdate(k,4)-N>Thresh)               %G-N>T
            ind=strfind(reshape(Agents',1,[]),AgentsToUpdate(k,:));         %Find agent in agent vector
            ind=ceil(ind/size(Agents,2));
            Agents(ind(1),3)=1;                                %and update it too
        
            Map(Agents(ind(1),1),Agents(ind(1),2),2)=1;                       %CHECK: if you allow more people in same place
        else
            ind=strfind(reshape(Agents',1,[]),AgentsToUpdate(k,:));         %Find agent in agent vector
            ind=ceil(ind/size(Agents,2));
            Agents(ind(1),3)=0;
            
            Map(Agents(ind(1),1),Agents(ind(1),2),2)=0;                       %CHECK: if you allow more people in same place
        end
        
        
        

    end
%     imshow(Map(:,:,1));    %Uncomment if you want to see people move ^^
%     pause
%     hold on
end





end
