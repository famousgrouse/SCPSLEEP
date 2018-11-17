%% Other Baselines:
clear;clc;
di=dir('..\face_images\*.bmp');
%% Setup

train_set=1:13;
test_set=14:26;
%%
Xtrain=[];Ytrain=[];
Xtest=[];Ytest=[];
for i=1:length(di)
    img=imread([di(i).folder,'\',di(i).name]);
    
    id=str2double(di(i).name(3:5));
    if i>650
        id=id+50;
    end
    if ismember(str2double(di(i).name(7:8)),train_set)
        Xtrain=[Xtrain;img(:)'];
        Ytrain=[Ytrain;id];
    end
    if ismember(str2double(di(i).name(7:8)),test_set)
        Xtest=[Xtest;img(:)'];
        Ytest=[Ytest;id];
    end
    
    disp([num2str(i),'/',num2str(2600)]);
end
save Benchmark X* Y*;