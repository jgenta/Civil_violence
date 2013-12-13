function [Npas]=count_pas(Agents)
%% ----Counts number of free, passive agents----
%input: Agents vector, output: number of free, passive agents    
Npas=0;
for i=1:size(Agents,1)
    if (Agents(i,6)==0&&Agents(i,3)==0)
        Npas=Npas+1;
    end
end

end