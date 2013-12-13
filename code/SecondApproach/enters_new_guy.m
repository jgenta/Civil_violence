function [newGuy]=enters_new_guy(oldGuy, Map, L, Agent)

%% ---Substitutes an agent/cop who is exiting the boundary with a new one, in a random place at boundary---
% Input:
% -a vector containing information about the agent/cop who is gong to exit the domain
% -the grid containing positions of all agents and cops
% -Legitimacy level (to evaluate new grievance) 
% -A flag telling wether we are dealing with an agent(=1) or a cop(=0)
%
% Output:
% -A new agent/cop, with a new position at the border (and eventually new values of
%  grievance and risk aversion)
%
% How it works:
% Finds all possible free places at the border (where a new agent/cop can appear)
% Randomly picks one of those
% Creates a new agent/cop placed there
% 
% REMARKS:
% !!!!ORIGINAL MAP MATRIX AND AGENT/COP VECTOR ARE NOT UPDATED!!!!
% --->This has to be done in move_people


newGuy=oldGuy;

% Current position of the agent/cop is going to be count as free
FreePlaces=[oldGuy(1),oldGuy(2)];

% Find the free places at the border
for i=1:size(Map,1)
    if (Map(i,1,1)==0 && Map(i,1,3)==0)
        FreePlaces=[FreePlaces; i,1];
    end
    if (Map(i,size(Map,2),1)==0 && Map(i,size(Map,2),3)==0)
        FreePlaces=[FreePlaces; i,size(Map,2)];
    end
end

for j=1:size(Map,2)
    if (Map(1,j,1)==0 && Map(1,j,3)==0)
        FreePlaces=[FreePlaces; 1,j];
    end
    if (Map(size(Map,1),j,1)==0 && Map(size(Map,1),j,3)==0)
        FreePlaces=[FreePlaces; size(Map,1),j];
    end
end

% And pick one of those randomly
FreePlaces=FreePlaces(randsample(size(FreePlaces,1),size(FreePlaces,1)),:);

% A new agent/cop will appear there
newGuy(1)=FreePlaces(1,1);
newGuy(2)=FreePlaces(1,2);

% If he is an agent, set him:
if (Agent)

%   Inactive at beginning (but this will be changed in move_people)
    newGuy(3)=0;
    
%   And with random grievance and risk aversion
    newGuy(4)=rand()*(1-L);
    newGuy(5)=rand();
end

end
