clear all
close all
clc

%% sweeps through the main using different value combinations for L and Thresh; can also be changed to check other values
minL=0;                                                                                     %minimum value for L
maxL=1;                                                                                     %maximum value for L
stepL=0.2;                                                                                  %stepsize for L variation
minTresh=0;                                                                                 %minimum value for G
maxThresh=1;                                                                                %m  aximum value for G
stepThresh=0.2;                                                                             %stepsize for G variation
repeats=2;                                                                                  %number of repeats for each combination to be averaged
counterL=1;                                                                                 %counts which iteration for L it is
counterThresh=1;                                                                            %counts which iteration for Thresh it is
absmediachange=0.6;                                                                         %absolute change of media that is done
changesteps=4;                                                                              %decides in how many steps the changes are done


for L=minL:stepL:maxL                                                                       %sweep through all L values
    L
    counterThresh=1;
    for Thresh=minTresh:stepThresh:maxThresh                                                %sweep through all T values
        Thresh
        summaxactive=0;
        for iterations=1:repeats
            maxactive(counterL,counterThresh)=main(L,Thresh,absmediachange,changesteps);	%get number of active people
            summaxactive=summaxactive+maxactive(counterL,counterThresh);					%for calculating mean
        end
        avmaxactive(counterL,counterThresh)=summaxactive/repeats;							%save the mean in a matrix
        counterThresh=counterThresh+1;														%go to next position
    end
    counterL=counterL+1;																	%go to next position
end

Lv=[];                                                                                      %create vector containing all Ls
for L=minL:stepL:maxL
    Lv=[Lv; L];
end
Threshv=[];
for Thresh=minTresh:stepThresh:maxThresh                                                    %create vector containing all Threshs
    Threshv=[Threshv; Thresh]
end

%surf(Lv,Threshv,avmaxactive)                                                               %make a 3D plot
