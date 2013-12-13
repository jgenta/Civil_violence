function [ind]=find_guy(group, guy)
%% ---Find an agent/cop in group vector---
% Input:
% -a vector containing all People (Cops or Agents)
% -an element (cop or agent) of that vector
%
% Output:
% -Index of the guy we want to find in group vector

ind=strfind(reshape(group',1,[]),guy);
ind=ceil(ind/size(group,2));

end
