function [MaxClust,Actives] = civil_violence_main(Size,Pd,Cd,L,Thresh,J,maxT,SocialMedia)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Main function. 
% ---------------------------Input Variables-------------------------------
% - Size: size of the grid.  
% - Pd: density of agents
% - Cd: density of cops
% - L: Government legitimacy
% - Thresh: threshold to decide whether to turn active or not
% - maxT: maximum time steps number
% - J: maximum jail term 
% - SocialMedia: flag for agents' global vision
% For more details see the report:
% http://
% --------------------------Output Variables-------------------------------
% - MaxClust: vector that contains sizes of biggest cluster of active 
%             people at each time step.
% - Actives: vector that contains the number of active people at each
%             timestep.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialization
% Matrix containing positions of People (:,:,1), active People(:,:,2) 
% and Cops (:,:,3)
Grid=zeros(Size,Size,3);  
a=rand(Size);
% Distributing People according to Pd
Grid(:,:,1)=double(a<Pd);            
%Distributing Cops according to Cd
Grid(:,:,3)=double(a<(Cd+Pd)).*double(a>Pd); 

% temp=1:Size;
% temp=temp<(Size/4);
% Grid(:,:,1)=double(temp')*double(temp);
% Grid(Size,Size,1)=1;
% Grid(Size,1,1)=1;
% Grid(1,Size,1)=1;
% Grid(:,:,2)=zeros(Size,Size);
% Grid(:,:,3)=zeros(Size,Size);
% Grid(Size,ceil(Size/2),3)=1;

%Probability Parameter K
% 1-exp(k)equals the probability of being captured with nC/nA=1
K=log(0.1); 

%Hardship matrix
%Perceived Hardship is uniformally distributed [0,1]
H=Grid(:,:,1).*rand(Size);

%Grievance matrix
%Grievance takes values in [0,1]
G=H.*(1-L);                 

%Risk aversion matrix
%Risk aversion is uniformally distributed [0,1]
R=Grid(:,:,1).*rand(Size);            

vp=ones(3,3);

%Arrest probability
NC=conv2(Grid(:,:,3),vp, 'same');          %Count visible cops on each (i,j) position and save them in a matrix
NP=conv2(Grid(:,:,2),vp, 'same');          %Count visible active people on each (i,j) position (now it's 0)

P=1-exp(K*(NC./(NP+1)));    %evaluate arrest probability --> k is negative!
N=R.*P;                     %Net risk=risk aversion * arrest probability: if it's high, I really don't want to turn active

Grid(:,:,2)=Grid(:,:,1).*double((G-N)>Thresh);

MaxClust=[];
Actives=[];
%% Initializing Agents and Cops vectors

Agents=zeros(sum(sum(Grid(:,:,1))),7);         % Vector containing people's information:
                                                 % (x,y) position in Grid: x->(:,1), y->(:,2)                                       
                                                 % Active or Inactive: 1/0 (:,3) 
                                                 % Grievance Level (:,4)
                                                 % Risk Aversion (:,5)
                                                 % Jail Term (:,6)
                                                 % Some other stuff that could come back in handy if that is the case (:,7)
                                                 
Cops=zeros(sum(sum(Grid(:,:,3))),3);           % Vector containing cops' information:
                                                 %(x,y) position in Grid
                                                 %Might come back useful
kagents=1;
kcops=1;
for i=1:size(Grid,1)
    for j=1:size(Grid,2)
        if(Grid(i,j,1)==1)                     % Check every person in the grid
            Agents(kagents,1)=i;                 %save info about him
            Agents(kagents,2)=j;
            Agents(kagents,3)=Grid(i,j,2);
            Agents(kagents,4)=G(i,j);
            Agents(kagents,5)=R(i,j);
            kagents=kagents+1;
        end
        if(Grid(i,j,3)==1)
            Cops(kcops,1)=i;                   %same for cops
            Cops(kcops,2)=j;
            kcops=kcops+1;
        end
    end
end
                                                 


if SocialMedia
    vp_force=Size;
else
    vp_force=1;
end
vp=2;
vc=2;


%% Start cycle
% Now the initial stage is set: let the show begin!matlab.mat
[Grid]=fill_playground(Agents, Cops,Size);
for t=1:maxT
    
    [ ~, mobs_size] = PostOnFacebook(Grid);
    
    MaxClust(t) = max(mobs_size);
    Actives(t)=sum(mobs_size);
    [Agents, Cops, Grid]=move_people_forces(Agents, Cops, Grid,vc, vp, L, K, Thresh,vp_force);
    
    
   

    
    [Agents, Cops, Grid]=decide(Agents, Cops, Grid, K,vp, Thresh);
    
    [Agents, Cops, Grid]=Arrest(Agents, Cops, Grid,vc, J);
    
    [Agents, Grid]=JailUpdate(Agents, Grid);
     %visualize(Grid);
end
    
        
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
