function [maxactive,Nactive,time,mediapercentage]=main(L,Thresh,absmediachange,changesteps)

%%version of the main to be called in sweep function
    %definition of L, Thresh, absmediachange and changesteps have been deleted and are taken as input
    %for the function. Possible to change it

%% Setting Parameters

Size=40;                                                                    %Area size

Pd=0.7;                                                                     %Population density
Cd=0.05;                                                                    %Cops density
NJail=0;                                                                    %initializing number of jailed people with 0
Grid=zeros(Size,Size,3);                                                    %matrix containing positions of People (:,:,1), active People(:,:,2) and Cops (:,:,3)

maxactive=0;                                                                %initializing maximum number of active people with 0

K=log(0.1);                                                                 %1-exp(k)equals the probability of being captured with nC/nA=1

media=1;                                                                    %1 or 0 (on or off)

mediaperc=0;                                                                %percentage of people with access to media

mediaimp=0;                                                                 %impact of media on threshold

maxT=160;                                                                   %Select number of iterations TO CHANGE

J=30;                                                                       %Jail Term

%% Initializing the domain Grid
a=rand(Size);
Grid(:,:,1)=double(a<Pd);                                                   %Distributing People
Grid(:,:,3)=double(a<(Cd+Pd)).*double(a>Pd);                                %Distributing Cops
% temp=1:Size;
% temp=temp<(Size/4);
% Grid(:,:,1)=double(temp')*double(temp);
% Grid(Size,Size,1)=1;
% Grid(Size,1,1)=1;
% Grid(1,Size,1)=1;
% Grid(:,:,2)=zeros(Size,Size);
% Grid(:,:,3)=zeros(Size,Size);

%% Initializing view spaces vp and vc

vc=ones(3,3);                                                               % 1 1 1
                                                                            % 1 1 1
                                                                            % 1 1 1
vp=ones(3,3);

%% Initializing H, G, R P and M matrixes

%Hardship matrix
H=Grid(:,:,1).*rand(Size);                                                  %Perceived Hardship is uniformally distributed (0:1)

G=H.*(1-L);                                                                 %Grievance matrix

%Risk propension matrix
R=Grid(:,:,1).*rand(Size);                                                  %Risk aversion is uniformally distributed (0:1)

%Arrest probability
NC=conv2(Grid(:,:,3),vp, 'same');                                           %Count visible cops on each (i,j) position and save them in a matrix
NP=conv2(Grid(:,:,2),vp, 'same');                                           %Count visible active people on each (i,j) position (now it's 0)

P=1-exp(K*(NC./(NP+1)));                                                    %evaluate arrest probability --> k is negative!
N=R.*P;                                                                     %Net risk=risk aversion * arrest probability: if it's high, I really don't want to turn active

Grid(:,:,2)=Grid(:,:,1).*double((G-N)>Thresh);                              %initializing active/inactive state of agents

%Media matrix
M=Grid(:,:,1).*rand(Size);                                                  %Media term is uniformally distributed (0:1) if value for single agent lies below mediaperc, media will have an influence on him
    

%% Initializing Agents and Cops vectors

Agents=zeros(sum(sum(Grid(:,:,1))),7);                                      % Vector containing people's information:
                                                                              % (x,y) position in Grid: x->(:,1), y->(:,2)                                       
                                                                              % Active or Inactive: 1/0 (:,3) 
                                                                              % Grievance Level (:,4)
                                                                              % Risk Aversion (:,5)
                                                                              % Jail Term (:,6)
                                                                              % media term (:,7)
                                                                              % Some other stuff that could come back in handy if that is the case (:,8)
                                                 
Cops=zeros(sum(sum(Grid(:,:,3))),3);                                        % Vector containing cops' information:
                                                                              %(x,y) position in Grid
                                                                              %Might come back useful
kagents=1;
kcops=1;
for i=1:size(Grid,1)
    for j=1:size(Grid,2)
        if(Grid(i,j,1)==1)                                                  % Check every person in the grid
            Agents(kagents,1)=i;                                            %save info about him
            Agents(kagents,2)=j;
            Agents(kagents,3)=Grid(i,j,2);
            Agents(kagents,4)=G(i,j);
            Agents(kagents,5)=R(i,j);
            Agents(kagents,7)=M(i,j);
            kagents=kagents+1;
        end
        if(Grid(i,j,3)==1)
            Cops(kcops,1)=i;                                                %same for cops
            Cops(kcops,2)=j;
            kcops=kcops+1;
        end
    end
end
                                                 

vp=2;                                                                       %initialize vision of agents and cops
vc=2;

Nearest=[];
% Now the initial stage is set: let the show begin!


%% Start cycle
[Grid]=fill_playground(Agents, Cops,Size);

%initialize vectors containing information on number of active, jailed,
%free and passive people for each timestep
Nactive=zeros(1,maxT);
Ncap=zeros(1,maxT);
Nfree=zeros(1,maxT);
Npas=zeros(1,maxT);
Nactive(1)=count_active(Agents);
time=[];                                                                            %initializing time as empty vector
mediapercentage=[];
%%time-loop
for t=1:maxT
    if t>50&&t<=(50+changesteps)                                                    %increasing percentage of people connected to internet, starting at timestep 50 in defined number of steps from 0 up to absmediachange
        mediaperc=mediaperc+absmediachange/changesteps;
    end
    
    %[Thresh, mobs, mobs_size]=broadcast_news(Grid, Thresh);
    
    %[Nearest] = getNearest(Grid(:,:,1),mobs,mobs_size);
   if t>1                                                                           %look at previous number of active and free people (needed for update of media term)
        Nactive(t)=Nactive(t-1);
        Nfree(t)=Nfree(t-1);
   end
    

    [Agents, Cops, Grid]=move_people_old(Agents, Cops, Grid,vc, vp);                %let people move to random empty spot within vision (not directed)

%     [Agents, L]=updateG(Agents, L,t);
    
    mediaimp=updatemedia(mediaimp,Thresh,Nfree,Nactive,t);                          %update the media term
    
    if media==1                                                                     %decision of agents is dependent on whether media is activated or not
        [Agents, Cops, Map]=decidemedia(Agents, Cops, Grid,K,vp, Thresh, media, mediaperc, mediaimp, Size);
    else
        [Agents, Cops, Grid]=deciden(Agents, Cops, Grid, K,vp, Thresh, Size);
    end
    
   
   
     [Agents, Cops, Grid, NJail]=Arrestn(Agents, Cops, Grid,vc, J, NJail, Size);    %cops arrest people
    %%count numbers of agents, save timestep in vector...
     Nactive(t)=count_active(Agents);
%     visualize(Grid)
    Ncap(t)=count_jail(Agents);
    Nfree(t)=count_free(Agents);
    Npas(t)=count_pas(Agents); 
    [Agents, Grid]=JailUpdate(Agents, Grid);
    Nactive(t)=count_active(Agents);
    time=[time;t];
    mediapercentage=[mediapercentage;mediaperc];
%% calculate maximum value if active people during the sweep
    if t>40 && (Nactive(t)>maxactive)
        maxactive=Nactive(t);
    end
end
    
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
