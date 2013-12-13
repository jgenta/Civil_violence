function [Ncap]=count_jail(Agents)
%%count all the people in jail
%input: Agents vector; output: number of jailed people

% Ncap=0;
% for i=1:size(Agents,1)
%     if (Agents(i,6)>0)
%         Ncap=Ncap+1;
%     end
% end

Ncap=sum(Agents(:,6)>0);

end