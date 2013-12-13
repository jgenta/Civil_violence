%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Script to run simulations with different parameters
clear all
close all
clc
% Vectors to store results
MaxClusterSizeLocal=zeros(10,200,5,5,5);
MaxClusterSizeGlobal=zeros(10,200,5,5,5);
ActivesLocal=zeros(10,200,5,5,5);
ActivesGlobal=zeros(10,200,5,5,5);

% Set Values of the parameters
Legitimacy = 0.1:0.2:0.9;
Threshold = -0.4:0.2:0.4;
Cops = [0.01,0.02,0.05,0.08,0.09];

% Start Simulations : 10 per parameters' combination
for z=1:5
    for j=1:5
        for k=1:5
            for i = 1:10
                disp(strcat('Simulation Number ',num2str(i),': Local'))
                [MaxClusterSizeLocal(i,:,j,k,z),ActivesLocal(i,:,j,k,z)]=civil_violence_main(20,0.2,Cops(z),Legitimacy(j),Threshold(k),10,200,0);
                disp(strcat('Simulation Number ',num2str(i),': Global'))
                [MaxClusterSizeGlobal(i,:,j,k,z),ActivesGlobal(i,:,j,k,z)]=civil_violence_main(20,0.2,Cops(z),Legitimacy(j),Threshold(k),10,200,1);
            end
        end
    end
end

save results.mat
