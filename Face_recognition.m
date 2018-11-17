%%
clear;clc;
load('Gallery');
load('Benchmark');
%di=dir('..\test\*.mat');

%% Setup:
t_set=14:26; %<--- Test samples can also be adjusted.

K=18;GT=[];
%% Face Recognition

Predict=[];
tic;
for i=1:1300
    %if ismember(str2double(di(i).name(7:8)),t_set)
    %the input data should be 15x6x243    
    %load([di(i).folder,'\',di(i).name],'feature_12');
    %load(dir(0),'feature_12');
    %Ben: this is the simulaiton code.
    feature_12 = randi([0,255], [6,243,15]);
    
    [pred, idx1, dist1, W1] =SCP(feature_12,G,Y,K);
    [pred1, idx2, dist2, W2]=SCP2(feature_12,G,Y,K);
    Predict=[Predict;pred];

    id=str2double(di(i).name(3:5));
    if i>650
        id=id+50;
    end
    GT=[GT;id];

    disp([num2str(i),'/',num2str(1300),':[',num2str(id),']--->[',num2str(pred),'] elapsed time:',num2str(toc)]);
    %end   
end

acc=sum(Predict==GT)/length(Predict);
%% SCP
