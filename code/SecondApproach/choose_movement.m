function [moveTo]=choose_movement(PossiblePlaces, InterestingPoint, grievance, active, gThresh, probFact, random)

%% ---Chooses position to move to---
% Input:
% -a vector containing all Possible places (i,j) an agent can move to
% -position of point of interest (closer riot group)
% -grievance level of an agent
% -whether the agent is active or not
% -a Threshold (to decide whether to move towards the riot or away from it)
% -a factor indicating how the probability to move towards a certain place scales with distance
% -a flag telling wether to keep random movement or not 
%
% Output:
% -Position (i,j) where to move to
%
%
% How it works:
% Evaluates distances between the point of interest and each of the possible places the agent can move to
% Sorts them and group points to move to according to distances
% Assigns to each point in the group a probability, so that:
% -points at a smaller distance got higher probability to be chosen
% -points at the same distance got the same probability to be chosen
% -points at a immediately higher distance got 1/probFact probability to be chosen with respect to those immediately closer
% Based on all this, randomly decides where to move to, taking into account
% that, if grievance is >gThresh, the agent tends to move towards the riot,
% and viceversa
% 
% If the "random" flag is switched off, it just moves to the closer position



% Create a vector containing all taxi-driver distances between PossiblePlaces and the place he would like to go (longest line ever)                        
distances=abs(PossiblePlaces(:,1)-ones(size(PossiblePlaces,1),1)*InterestingPoint(1))+abs(PossiblePlaces(:,2)-ones(size(PossiblePlaces,1),1)*InterestingPoint(2));

% Sort Possible Position in order of distance
[~,indexes]=sortrows(distances);

% If the random flag is on, keep a randomness in the movement:
if (random)
    
    groups=zeros(2,size(indexes,1));
    groups(1,:)=indexes';
    j=1;
    
    groups(2,1)=j;

%   To do so, first group possible places to move to according to distances
    for i=2:length(indexes)
        if distances(indexes(i))>distances(indexes(i-1))
            j=j+1;
        end
        
        groups(2,i)=j;
    end
    
%   And assign each goup a Prob, so that it decreases as distance increases
    denom=0;
    Prob=zeros(1,size(groups,2));
    
    for i=1:size(groups,2)
        denom=denom+probFact^(groups(2,size(groups,2))-groups(2,i));
        Prob(i)=probFact^(groups(2,size(groups,2))-groups(2,i));
    end

    
    Prob=Prob/denom;

%   Evaluate partial probabilities to create intervals of probabilities
    Prob=cumsum(Prob);
    
    x=rand();
    i=0;
    chosen=1;
    
%   Choose where to move to, according to probability and grievance:    
    while i<length(Prob)
        i=i+1;
        
        if x<Prob(i)
            
%           if the grievance is low enough, and you're not active    
            if (~active && grievance<gThresh)
%               step away from it
                chosen=indexes(length(indexes)-i+1);
            
            else
%               else move towards the riot                
                chosen=indexes(i);
            
            end
            
            i=length(Prob);
        end
    end
else
    
%   While, if random movement is neglected, just move as close as possible to the riot
    chosen=indexes(1);
    
end


moveTo=PossiblePlaces(chosen,:);

end
