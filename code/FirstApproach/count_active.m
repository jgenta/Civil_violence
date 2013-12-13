function [Nactive]=count_active(Agents)

%% ----Counts number of active agents----
%input: Agents vector, output: number of active agents
Nactive=0;
for i=1:size(Agents,1)
    Nactive=Agents(i,3)+Nactive;
end

end