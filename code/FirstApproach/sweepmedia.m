clear all
clc

%% sweeps through the main using different value combinations for L and Thresh; can also be changed to check other values
% main is now used used as a function with parameters to be changed during runs as input!!!
L=0.2;                                                                                                  %mvalue for L
Thresh=0.6;                                                                                             %value for G
repeats=1;                                                                                              %number of repeats for each combination to be averaged
countersteps=1;                                                                                         %counts which iteration for L it is
counterThresh=1;                                                                                        %counts which iteration for Thresh it is
absmediachange=0.6;                                                                                     %absolute change of media that is done
changestepsmin=4;                                                                                       %decides in how many steps the changes are done
changestepsmax=4;
stepsv=[];

%%loop through different configurations, save values for each configuration in a matrix
for steps=changestepsmin:2:changestepsmax
    steps                                                                                               %to observe how far the run got
    summaxactive=0;                                                                                     %has to be reset before each loop
    for iterations=1:repeats
        max(iterations)=0;                                                                              %has to be reset always
        [maxactive(countersteps),Nactive,time,mediapercentage]=main(L,Thresh,absmediachange,steps);     %output of values
        max(iterations)=maxactive(countersteps);                                                        %for calculation of error
        summaxactive=summaxactive+maxactive(countersteps);                                              %for calculation of mean
    end
        avmaxactive(countersteps)=summaxactive/repeats;                                                 %calculation of mean
        squaresum=0;
    for iterations=1:repeats
        squaresum=squaresum+(max(iterations)-avmaxactive(countersteps))^2;                              %needed for calculation of error
    end
        deviation(countersteps)=sqrt(squaresum/(repeats*(repeats-1)))                                   %deviation of mean value (matrix)
        stepsv=[stepsv; steps];                                                                         %creating vector for plotting later on
        countersteps=countersteps+1;
    end

percerror=deviation./avmaxactive;                                                                       %error in percent of mean value (matrix)



