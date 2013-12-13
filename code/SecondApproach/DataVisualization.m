%load results.mat
close all
Legitimacy = 0.1:0.2:0.9;
Threshold = -0.4:0.2:0.4;
Cops = [0.01,0.02,0.05,0.08,0.09];
MCG = mean(MaxClusterSizeGlobal,1);
MCL = mean(MaxClusterSizeLocal,1);
MAG = mean(ActivesGlobal,1);
MAL = mean(ActivesLocal,1);
for k = 1:5
    figure('Name',strcat('Threshold = ',num2str(Threshold(k))));
    count = 1;
    for j = 1:5
        for z = 1:5
            subplot(5,5,count)
            plot(MCG(1,:,j,k,z))
            hold on
            plot(MCL(1,:,j,k,z),'-r')
            xlabel({'Time steps',strcat('CD = ',num2str(Cops(z)),' L = ',num2str(Legitimacy(j)))})
            ylabel('Number of people')
            count = count + 1;
        end
    end
end
  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
close all

for k = 1:5
    figure('Name',strcat('Threshold = ',num2str(Threshold(k))));
    count = 1;
    for j = 1:5
        for z = 1:5
            subplot(5,5,count)
            plot(MAG(1,:,j,k,z))
            hold on
            plot(MAL(1,:,j,k,z),'-r')
            xlabel({'Time steps',strcat('CD = ',num2str(Cops(z)),' L = ',num2str(Legitimacy(j)))})
            ylabel('Number of people')
            count = count + 1;
        end
    end
end