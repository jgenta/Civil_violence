function [mediaimp]=updatemedia(mediaimp, Thresh,Nfree,Nactive,t)

%% ----Counts the percentage of people being active and calculates the impact on threshold----
% input: old value, Threshhold, vector with number of free and active
% agents, timestep
% Improvements done:
% Counting number of agents in main (has to be done only once)
% improve formula to give proper results (add a factor since offset doesn't make too much sense, maybe also a threshold???)

%% Calculation
if 5*Thresh*Nactive(t)/Nfree(t)<=Thresh                                     %between 0 (no agents active) and Thresh (all active)
   mediaimp=5*Thresh*Nactive(t)/Nfree(t);
else                                                                        %if-condition makes sure, Threshold doesn't drop below zero (can cause all agents to irreversibly turn actve => crash)
    mediaimp=Thresh;
end