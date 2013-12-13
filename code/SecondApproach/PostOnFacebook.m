function [mobs,mobs_size]=PostOnFacebook(grid)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Supporting function to evaluate mobs sizes and keep track of agents 
% position in the mob
% Input:
% - a NxNx3 data structure containing map of people, actives and cops
% Output:
% - new threshold value
% - a vector of mobs' sizes, i.e. mobs_size = [size_1 size_2 ... size_k]
% - a vector containing actives' positions ordered by mob's belonging.
% NOTE: a mob, in this implementation, is a group of CONTIGUOS people.     

% Actives to count
actives = grid(:,:,2);
% Grid dimensions
columns=size(actives,2);
rows=size(actives,1);
% Initialization
mobs=[];
mobs_size=0;
to_check = [];
% Supporting variable: if =0 then there are no active to count anymore --> loop stops
checking = sum(sum(actives));
% First order Moore neighbourhood
neighbour = [0 1;    %east
    0 -1;   %west
    -1 0;   %north
    1 0;    %south
    -1 -1;  %north_west
    -1 1;   %north_east
    1 -1;   %south_west
    1 1];   %south_east

% Starting Loop 
while (checking)

    % Find a non-counted active agent
    starting_point=0;
    while (~starting_point && i<=rows && j<=columns)
        starting_point=actives(i,j);
        j=j+(~starting_point);
        i=i+(j>columns)*(~starting_point);
        j=j*(j<=columns)+(j>columns);
    end
    % From agent in position (i,j) it looks for every active in the same mob 
    to_check=[i,j];
    to_check_size=starting_point;
    count = 0;
    while to_check_size>0
        count = count+1;
        i=to_check(1,1);
        j=to_check(1,2);
        actives(i,j)=0;
        mobs=[mobs; i,j];
        neigh=neighbour;
        % Check if the neighbourhood is in the grid boundaries
        if (i==rows)
            neigh(neigh(:,1)==1,:)=[];
        end
        if (j==columns)
            neigh(neigh(:,2)==1,:)=[];
        end
        if (i==1)
            neigh(neigh(:,1)==-1,:)=[];
        end
        if (j==1)
            neigh(neigh(:,2)==-1,:)=[];
        end
        
        % Check the current agent's neighbourhood
        for k=1:size(neigh,1)
            I = i+neigh(k,1);
            J = j+neigh(k,2);
            if (actives(I,J))
                to_check=[to_check;I,J];
            end
        end

        to_check(1,:) = []; % Remove the current agent from agents to be counted
        to_check=unique(to_check,'rows'); % To avoid to repeat the same check
        to_check_size = size(to_check,1);
    end
    mobs_size = [mobs_size;count];
    checking=sum(sum(actives));
end
end


