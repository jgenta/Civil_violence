function [Agents, Cops, Map, NJail]=Arrestn(AgentsOld, CopsOld, MapOld,vc, J,NJail, Size)

%% ----Makes Arrest decision for every cop----
% 
% Improvements to be done:


NJail=0;
Agents=AgentsOld;
Cops=CopsOld;
Map=MapOld;

%% Random Update:

CopsToAct=Cops(randsample(size(Cops,1),size(Cops,1)),:);                    %Shuffle elements in Cops

for k=1:size(CopsToAct,1)                                                   %Go through all cops
        
    ActiveAgents=[];
    Neigh=check_neigh(Map, CopsToAct, k, vc, Size);
    for a=1:size(Neigh,1)                                                   %go through the places around him (border control included)
        if Map(Neigh(a,1),Neigh(a,2),2)==1                                  %if there is an active agent on that places
            ActiveAgents=[ActiveAgents; Neigh(a,1),Neigh(a,2)];
        end
    end
%     ar=rand;
    if size(ActiveAgents,1)>0                                               %If you can arrest somebody...
        CapturedAgent=ActiveAgents(ceil(rand()*size(ActiveAgents,1)),:);    %randomly chose active agent to capture
        NJail=NJail+1;                                                      %increase number of jailed people by 1
        Map(CapturedAgent(1),CapturedAgent(2),1)=0;                         %remove him from lattice
        Map(CapturedAgent(1),CapturedAgent(2),2)=0;
        Agpos=0;
        con=1;
        while (con==1)
            Agpos=Agpos+1;                                                  %find him in Agents vector
            if (Agents(Agpos,1)==CapturedAgent(1) && Agents(Agpos,2)==CapturedAgent(2)) 
                con=0;
            end
        end
        
        
        Agents(Agpos,6)=ceil(J*rand);                                       %assign jail term
        Agents(Agpos,1)=0;                                                  %also update his position
        Agents(Agpos,2)=0;
        Agents(Agpos,3)=0;                                                  %make him inactive
    end
end

		


end
