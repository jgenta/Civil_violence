function [Agents, Cops, Map]=move_people_old(AgentsOld, CopsOld, MapOld, vc, vp)

%% ----Moves Agents and Cops in Map, updating their position randomly----
% 
% Improvements to be done:
% 

Preferences=[];
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
        
        if (0)                                                                      %create a vector containing all taxi-driver distances between PossiblePlaces and the place he would like to go (longest line ever)
            distances=abs(PossiblePlaces(:,1)-ones(size(PossiblePlaces,1),1)*Preferences(AgentsToMove(k,1),AgentsToMove(k,2),1))+abs(PossiblePlaces(:,2)-ones(size(PossiblePlaces,1),1)*Preferences(AgentsToMove(k,1),AgentsToMove(k,2),2));
            
            
            [~,indexes]=sortrows(distances);                                        %sort Possible Position in order of distance
            %chosen=indexes(1);                                                     %just move as close as possible
            
            groups=zeros(2,size(indexes,1));
            groups(1,:)=indexes';
            j=1;

            groups(2,1)=j;
            
            for i=2:length(indexes)                                 
                if distances(indexes(i))>distances(indexes(i-1))                    %group possible places to move to according to distances
                    j=j+1;
                end
                
                groups(2,i)=j;
            end
            
            probFact=4;                                                             %factor which indicates how probability scales increasing distance:
                                                                                    %prob to go to a place farther away=1/ProbFact probability to go to a closer
                                                                        
            denom=0;
            Prob=zeros(1,size(groups,2));
            
            for i=1:size(groups,2)
                denom=denom+probFact^(groups(2,size(groups,2))-groups(2,i));
                Prob(i)=probFact^(groups(2,size(groups,2))-groups(2,i));
            end
            Prob=Prob/denom;
            Prob=cumsum(Prob);                                                      %partial probabilities
            
            
            x=rand();
            i=0;
            chosen=1;
            
            while i<length(Prob)                                                    %choose where to move to, according to probability and grievance:
                i=i+1;
                
                if x<Prob(i)                                                        %GRIVANCE TO BE CHECKED
                    if (AgentsToMove(k,4)>0.2)                                      %if the grievance is high enough,
                        chosen=indexes(i);                                          %move towards the riot
                    else
                        chosen=indexes(length(indexes)-i+1);                        %else step away from it
                    end
                    i=length(Prob);
                end
            end
             
            moveTo=PossiblePlaces(chosen,:);
            
        else
            moveTo=PossiblePlaces(ceil(rand()*size(PossiblePlaces,1)),:);           %Choose randomly (with uniform probability) between available places:
                                                                                    %first generate a random number between 0 and the number of av. places
                                                                                    %then round it to the upper integer-->(ceil())
                                                                                    %lastly, take that position as the place to move to-->moveTo=...
        end
        
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