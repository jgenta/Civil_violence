function [Maps]=fill_playground(Agents, Cops,N)

%% ----Given a vector of Agents and Cops, fills the grid according to their attributes----



Maps=zeros(N,N,3);

for k=1:size(Agents,1)
    if Agents(k,6)==0                        %check jail term
        i=Agents(k,1);
        j=Agents(k,2);
        Maps(i,j,1)=Maps(i,j,1)+1;              %Add agents in the right position
        Maps(i,j,2)=Maps(i,j,2)+Agents(k,3);    %Add active agents in the right position
    end
end

for k=1:size(Cops,1)
    i=Cops(k,1);
    j=Cops(k,2);
    Maps(i,j,3)=Maps(i,j,3)+1;              %Add cops in the right position
end
end
