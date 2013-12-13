function [Neigh]=find_neigh(Map, person, k,v,Size )

%% checks the neighbors in vision of a person (input for person is Agents or Cops, for k it is the position of the person in the corresponding vector, for v the corresponding vision). Output is a vector containing all neighbors (necessary for periodic BCs)
    
Neigh=[];                                                                   %create Neigh vector

    for i=person(k,1)-v:person(k,1)+v
        for j=person(k,2)-v:person(k,2)+v
            if i<=0                                                         %out of lower boundary
                x=Size+i;
            elseif i>Size                                                   %out of upper boundary
                x=i-Size;
            else                                                            %inside boundaries
                x=i;
            end
            if j<=0                                                         %out of lower boundary
                y=Size+j;
            elseif j>Size                                                   %out of upper boundary
                y=j-Size;
            else
                y=j;                                                        %inside boundaries
            end
            Neigh=[Neigh; x,y];                                             %add the proper values to the Neigh vector
        end
    end
            

end
