%% the code is used to calculate the 
clear;clc;
di=dir('..\training\*.mat');

%% Setup:
t_set=1:13; %<--- You can use less training samples

%% Build-up the Gallery G and Label Y
G=cell(1,15);Y=[];
for i=1:1300 % 100 people and each people has 13 pictures
    if ismember(str2double(di(i).name(7:8)),t_set)
    
    load([di(i).folder,'\',di(i).name],'feature_12');
    for sc=1:15 %build up the gallery from subclass pooling output 15 x 7800 x 243
        G{sc}=[G{sc};feature_12(:,:,sc)];
    end
    id=str2double(di(i).name(3:5));
    if i>650
        id=id+50;
    end
    Y=[Y;ones(6,1)*id];
    %one picture represent one person, and one picture has 15 subclass
    %and each subclass has 6 patches, so we concate the patches into 
    % num_people & num_pics
    disp([num2str(i),'/',num2str(1300)]);
    
    end
end

save Gallery G Y;

