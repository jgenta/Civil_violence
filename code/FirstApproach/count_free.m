function [Nfree]=count_free(Agents)
%% ----Counts number of free agents----
%input: Agents vector, output: number of free agents    

% Nfree=0;
% for i=1:size(Agents,1)
%     if (Agents(i,6)==0)
%         Nfree=Nfree+1;
%     end
% end


Nfree=sum(Agents(:,6)==0);

end