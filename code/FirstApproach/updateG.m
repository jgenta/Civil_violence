function [Agents, Lnew]=updateG(Agents, Lold, t)

%% ----Sweeps through agents array and updates their legitimacy----
if (t>20)
    Lnew=0.6;
else
    Lnew=Lold;
end

% Lnew=Lold-0.9/100;


%% Update:
	
for k=1:size(Agents,1)                                                      %Update them one at a time
   H=Agents(k,4)/(1-Lold);                                                  %calculate old hardship
   Agents(k,4)=H*(1-Lnew);                                                  %Calculate new grievance
   
end





end
