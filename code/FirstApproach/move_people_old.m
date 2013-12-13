function [Agents, Cops, Map]=move_people_old(AgentsOld, CopsOld, MapOld, vc, vp)

%% ----Moves Agents and Cops in Map, updating their position randomly----
% 
% 

Agents=AgentsOld;
Cops=CopsOld;
Map=MapOld;

%% Random Update:
AgentsToMove=Agents(randsample(size(Agents,1),size(Agents,1)),:);                   %Shuffle elements in Agents and Cops
CopsToMove=Cops(randsample(size(Cops,1),size(Cops,1)),:);
	
for k=1:size(AgentsToMove,1)                                                        %Update them one at a time, Agents first:
    if AgentsToMove(k,6)==0                                                         %Do nothing if this guy is in jail
        PossiblePlaces=[AgentsToMove(k,1),AgentsToMove(k,2)];                       %check all possible places that an agent can move to:
        
        for i=max(AgentsToMove(k,1)-vp,1):min(AgentsToMove(k,1)+vp,size(Map,1))     %which are all the places around him (border control included)            
            for j=max(AgentsToMove(k,2)-vp,1):min(AgentsToMove(k,2)+vp,size(Map,2))
                if (Map(i,j,1)==0 && Map(i,j,3)==0)
                    PossiblePlaces=[PossiblePlaces; i,j];                           %that are not empty
                                                                                    %Remark: position currently occupied by agent k is not going 
                                                                                    %to be added twice...    
                end
            end
        end
        
        
        moveTo=PossiblePlaces(ceil(rand()*size(PossiblePlaces,1)),:);               %Choose randomly (with uniform probability) between available places:
                                                                                    %first generate a random number between 0 and the number of av. places
                                                                                    %then round it to the upper integer-->(ceil())
                                                                                    %lastly, take that position as the place to move to-->moveTo=...
        
        
        Map(AgentsToMove(k,1),AgentsToMove(k,2),1)=0;                               %Update Map matrix
        Map(moveTo(1),moveTo(2),1)=1;
        Map(AgentsToMove(k,1),AgentsToMove(k,2),2)=0;
        Map(moveTo(1),moveTo(2),2)=AgentsToMove(k,3);

        ind=strfind(reshape(Agents',1,[]),AgentsToMove(k,:));                       %Find agent in agent vector
        ind=ceil(ind/size(Agents,2));
        
        Agents(ind(1),1)=moveTo(1);                                                 %and update it too
        Agents(ind(1),2)=moveTo(2);
    
%       imshow(Map(:,:,1));                                                         %Uncomment if you want to see people move ^^
%       pause
%       hold on
    end
    
end


for k=1:size(CopsToMove,1)                                                          %Do the same with cops
        
    PossiblePlaces=[CopsToMove(k,1),CopsToMove(k,2)];
        
    for i=max(CopsToMove(k,1)-vc,1):min(CopsToMove(k,1)+vc,size(Map,1))
        for j=max(CopsToMove(k,2)-vc,1):min(CopsToMove(k,2)+vc,size(Map,2))
             if (Map(i,j,3)==0 && Map(i,j,1)==0)
               PossiblePlaces=[PossiblePlaces; i,j];
               
             end
        end
    end
        
    moveTo=PossiblePlaces(ceil(rand()*size(PossiblePlaces,1)),:);
    
    Map(CopsToMove(k,1),CopsToMove(k,2),3)=0;
    Map(moveTo(1),moveTo(2),3)=1;
    

	ind=strfind(reshape(Cops',1,[]),CopsToMove(k,:));
    ind=ceil(ind/size(Cops,2));
    Cops(ind,1)=moveTo(1);
    Cops(ind,2)=moveTo(2);
    
%    imshow(Map(:,:,3));                                                            %Uncomment if you want to see cops move ^^
%    pause
%    hold on
end



end