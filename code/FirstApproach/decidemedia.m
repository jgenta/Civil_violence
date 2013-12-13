function [Agents, Cops, Map]=decidemedia(AgentsOld, CopsOld, MapOld,K,vp, Thresh, mediaperc, mediaimp, Size)

%% ----Sweeps through agents array and updates their status---- 



Agents=AgentsOld;
Cops=CopsOld;
Map=MapOld;

%% Random Update:
AgentsToUpdate=Agents(randsample(size(Agents,1),size(Agents,1)),:);         %Shuffle elements in Agents and Cops
	
for k=1:size(AgentsToUpdate,1)                                              %Update them one at a time
    
   if AgentsToUpdate(k,6)==0
        Neigh=check_neigh(Map, AgentsToUpdate, k, vp, Size);                %create vector with all position within vision (periodic boundaries)
    	ActiveAgents=1-Map(AgentsToUpdate(k,1),AgentsToUpdate(k,1),2);      %check all places around for active agents and cops, initialize ActiveAgents with 1 or 0 depending wether he's active or not:
        NumberCops=0;                                                       %initialize number of cops with 0
        for a=1:size(Neigh,1)                                               %which are all the places around him (border control included)
                ActiveAgents=ActiveAgents+Map(Neigh(a,1),Neigh(a,2),2);     %increase number of agents by 1 for each agent in reach                                                       
                NumberCops=NumberCops+Map(Neigh(a,1),Neigh(a,2),3);         %increase number of cops by 1
        end
        
        P=1-exp(K*(NumberCops/(ActiveAgents)));                             %evaluate arrest probability --> k is negative!
        N=AgentsToUpdate(k,5)*P;                                            %Net risk=risk aversion * arrest probability: if it's high, I really don't want to turn active
        if (AgentsToUpdate(k,7)<=mediaperc)                       %behaviour of agents with access to media if media active
             if (AgentsToUpdate(k,4)-N>(Thresh-mediaimp))                   %G-N>T, where T is lowered by media
                ind=strfind(reshape(Agents',1,[]),AgentsToUpdate(k,:));     %Find agent in agent vector
                ind=ceil(ind/size(Agents,2));
                Agents(ind(1),3)=1;                                         %and update it too
        
                Map(Agents(ind(1),1),Agents(ind(1),2),2)=1;                 %CHECK: if you allow more people in same place
             else
                ind=strfind(reshape(Agents',1,[]),AgentsToUpdate(k,:));     %Find agent in agent vector
                ind=ceil(ind/size(Agents,2));
                Agents(ind(1),3)=0;
            
                Map(Agents(ind(1),1),Agents(ind(1),2),2)=0;                 %CHECK: if you allow more people in same place
            end
        else
            if (AgentsToUpdate(k,4)-N>Thresh)                               %regular behavement without/without access to media
                ind=strfind(reshape(Agents',1,[]),AgentsToUpdate(k,:));     %Find agent in agent vector
                ind=ceil(ind/size(Agents,2));
                Agents(ind(1),3)=1;                                         %and update it too
        
                Map(Agents(ind(1),1),Agents(ind(1),2),2)=1;                 %CHECK: if you allow more people in same place
            else
                ind=strfind(reshape(Agents',1,[]),AgentsToUpdate(k,:));     %Find agent in agent vector
                ind=ceil(ind/size(Agents,2));
                Agents(ind(1),3)=0;
            
                Map(Agents(ind(1),1),Agents(ind(1),2),2)=0;                 %CHECK: if you allow more people in same place
            end
        end
        
        
        

    end

end





end