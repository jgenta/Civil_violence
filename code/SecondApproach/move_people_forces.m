function [Agents, Cops, Map]=move_people_forces(AgentsOld, CopsOld, MapOld, vc, vp, L, K, Thresh,vp_force)

%% ----Moves Agents and Cops in Map, updating their position randomly----
% Input:
% -a vector containing all Agents' info
% -a vector containing all Cops' info
% -the Grid filled with agents and cops
% -agents' field of movement
% -cops' field of movement
% -legitimacy level
% -the k parameter for evaluating the probability to turn active
% -the threshold level
% -size of impact of the force
%
% Output:
% -updated vector containing all Agents' info
% -updated vector containing all Cops' info
% -updated grid
%
% How it works:
% Sorts agents vector so to update them randomly
% For each agent, check free position around him where he can move to
% For each agent, evaluate the attraction force acting on him. The force depends on the position of other agents and cops,
% 	on their distances, and on the size of the field of action
% Depending on force, current position and grievance, evaluate the position where he moves
% If that place is outside the boundary, make that agent disappear and create another one in a random free position at the boundary
% Update both Agents and Map matrixes
% 
% Do the same with cops

Agents=AgentsOld;
Cops=CopsOld;
Map=MapOld;

% Shuffle elements in Agents and Cops
AgentsToMove=Agents(randsample(size(Agents,1),size(Agents,1)),:);
CopsToMove=Cops(randsample(size(Cops,1),size(Cops,1)),:);

%% AGENTS UPDATE

% Update agents one at a time:
for k=1:size(AgentsToMove,1)
    
%   Do something only if this guy is not in jail
    if AgentsToMove(k,6)==0

%	    Evaluate forces    
        Force=[0,0]';

%		Depending on positions of the agents inside vp_force        
        for i=1:size(AgentsToMove,1)
            if (i~=k)
                taxiDist=abs(AgentsToMove(k,1)-AgentsToMove(i,1))+abs(AgentsToMove(k,2)-AgentsToMove(i,2));
                ok = (abs(AgentsToMove(k,1)-AgentsToMove(i,1))<=vp_force)*(abs(AgentsToMove(k,2)-AgentsToMove(i,2))<=vp_force);  
       
                Force(1)= Force(1)+2*ok*AgentsToMove(i,3)*AgentsToMove(k,3)/taxiDist*sign(AgentsToMove(i,2)-AgentsToMove(k,2))-10*ok*AgentsToMove(i,3)*(~AgentsToMove(k,3))/taxiDist*sign(AgentsToMove(i,2)-AgentsToMove(k,2));
                Force(2)= Force(2)+2*ok*AgentsToMove(i,3)*AgentsToMove(k,3)/taxiDist*sign(AgentsToMove(i,1)-AgentsToMove(k,1))-10*ok*AgentsToMove(i,3)*(~AgentsToMove(k,3))/taxiDist*sign(AgentsToMove(i,1)-AgentsToMove(k,1));
                
            end
        end
        
%		And on positions of the cops inside vp_force        
        for i=1:size(CopsToMove,1)
            taxiDist=abs(AgentsToMove(k,1)-CopsToMove(i,1))+abs(AgentsToMove(k,2)-CopsToMove(i,2));
            ok = (abs(AgentsToMove(k,1)-CopsToMove(i,1))<=vp_force)*(abs(AgentsToMove(k,2)-CopsToMove(i,2))<=vp_force)*AgentsToMove(k,3);  
            Force(1)= Force(1)-7*ok/taxiDist*sign(CopsToMove(i,2)-AgentsToMove(k,2));
            Force(2)= Force(2)-7*ok/taxiDist*sign(CopsToMove(i,1)-AgentsToMove(k,1));
            
        end


%		Find all the possible places the agents can move to (all those immediately around him that are not occupied)        
        PossiblePlaces=[AgentsToMove(k,1),AgentsToMove(k,2)];
        
        for i=AgentsToMove(k,1)-1 : AgentsToMove(k,1)+1
            for j=AgentsToMove(k,2)-1 : AgentsToMove(k,2)+1
                if (i>size(Map,1) || j>size(Map,2) || i<1 || j<1 || (Map(i,j,1)==0 && Map(i,j,3)==0))
                    PossiblePlaces=[PossiblePlaces; i,j];
                    
                end
            end
        end
        
%		Find the place he would like to move to, simply by adding the resulting force      
        InterestingPoint=[floor(AgentsToMove(k,1)+Force(2)), floor(AgentsToMove(k,2)+Force(1))];

%		And choose his position in the next step with a weighted probability        
        moveTo=choose_movement(PossiblePlaces, InterestingPoint, AgentsToMove(k,4),AgentsToMove(k,3), 0.2, norm(Force),1);
        
        
        
%       Find current agent in agents vector
        ind=find_guy(Agents, AgentsToMove(k,:));
        
        
%       BOUNDARY CONDITIONS: when an agent exits the boundary, make another
%       				     one pop up in a random position at the border
        
%       So, if an agent would like to move across the boundary,
        if (moveTo(1)>size(Map,1) || moveTo(1)<1 || moveTo(2)>size(Map,2) || moveTo(2)<1)

%           delete that agent and add a new one somewhere at the border
            [Agents(ind(1),:)]=enters_new_guy(AgentsToMove(k,:), Map, L, 1);
            moveTo=Agents(ind(1), 1:2);          %(this is just to update map and agent matrix well)
            
%           and set him active or not according to surroundings:
            ActiveAgents=1;
            NumberCops=0;
            
            for i=max(Agents(ind(1),1)-vp,1):min(Agents(ind(1),1)+vp,size(Map,1))
                for j=max(Agents(ind(1),2)-vp,1):min(Agents(ind(1),2)+vp,size(Map,2))
                    ActiveAgents=ActiveAgents+Map(i,j,2);
                    NumberCops=NumberCops+Map(i,j,3);
                end
            end
            
            P=1-exp(K*(NumberCops/(ActiveAgents)));
            N=Agents(ind(1),5)*P;
            
%           if G-N>T, go active
            if (Agents(ind(1),4)-N>Thresh)
                Agents(ind(1),3)=1;
            end
            
        end
        
%       Update Map matrix
        Map(AgentsToMove(k,1),AgentsToMove(k,2),1)=0;
        Map(moveTo(1),moveTo(2),1)=1;
        Map(AgentsToMove(k,1),AgentsToMove(k,2),2)=0;
        Map(moveTo(1),moveTo(2),2)=Agents(ind(1),3);
        
%       Update agent position too
        Agents(ind(1),1)=moveTo(1);
        Agents(ind(1),2)=moveTo(2);
        
        
    end
    
end




%% COPS UPDATE

% Do the same with cops: for each one, randomly chosen,
for k=1:size(CopsToMove,1)
    
    PossiblePlaces=[CopsToMove(k,1),CopsToMove(k,2)];
    
%   Check possible places where cops can move to
    for i=CopsToMove(k,1)-1 : CopsToMove(k,1)+1
        for j=CopsToMove(k,2)-1 : CopsToMove(k,2)+1
            if (i>size(Map,1) || j>size(Map,2) || i<1 || j<1 || (Map(i,j,1)==0 && Map(i,j,3)==0))
                PossiblePlaces=[PossiblePlaces; i,j];
                
            end
        end
    end
    
%	Evaluate the attraction forces acting on him
    Force=[0,0]';
    
    for i=1:size(AgentsToMove,1)
        if (~Agents(i,6))
            taxiDist=abs(CopsToMove(k,1)-AgentsToMove(i,1))+abs(CopsToMove(k,2)-AgentsToMove(i,2));
            Force(1)= Force(1)+10*AgentsToMove(k,3)/taxiDist*sign(AgentsToMove(i,2)-CopsToMove(k,2))-0.02*(~AgentsToMove(k,3))/taxiDist*sign(AgentsToMove(i,2)-CopsToMove(k,2));
            Force(2)= Force(2)+10*AgentsToMove(k,3)/taxiDist*sign(AgentsToMove(i,1)-CopsToMove(k,1))-0.02*(~AgentsToMove(k,3))/taxiDist*sign(AgentsToMove(i,1)-CopsToMove(k,1));
        end
    end
    
    for i=1:size(CopsToMove,1)
        if(i~=k)
            taxiDist=abs(CopsToMove(k,1)-CopsToMove(i,1))+abs(CopsToMove(k,2)-CopsToMove(i,2));
            Force(1)= Force(1)-5.7/taxiDist*sign(CopsToMove(i,2)-CopsToMove(k,2));
            Force(2)= Force(2)-5.7/taxiDist*sign(CopsToMove(i,1)-CopsToMove(k,1));
        end
    end
    
    
   
%	According to the force, evaluate the place where the cop moves    
    InterestingPoint=[floor(CopsToMove(k,1)+Force(2)), floor(CopsToMove(k,2)+Force(1))];
    
    moveTo=choose_movement(PossiblePlaces, InterestingPoint, 1,1, 0, norm(Force),1);
    
    
    
%   Find current cop in cops vector
    ind=find_guy(Cops, CopsToMove(k,:));
    
%   And again, if the cop would like to move across the boundary
    if (moveTo(1)>size(Map,1) || moveTo(1)<1 || moveTo(2)>size(Map,2) || moveTo(2)<1)
        
%       delete that cop and add a new one somewhere at the border
        [Cops(ind(1),:)]=enters_new_guy(CopsToMove(k,:), Map, L, 0);
        moveTo=Cops(ind(1), 1:2);                         %(this is to update map and cops matrix well)
        
    end

%	In the end, update the grid and the Cop vector    
    Map(CopsToMove(k,1),CopsToMove(k,2),3)=0;
    Map(moveTo(1),moveTo(2),3)=1;
    
    Cops(ind,1)=moveTo(1);
    Cops(ind,2)=moveTo(2);
    
    
end

end
