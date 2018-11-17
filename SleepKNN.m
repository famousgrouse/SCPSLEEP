clear;clc;
%get the environment variable for the dataset folder
%% read patient dataset
%fid  = fopen('.\Dataset\patient details.csv');
%patients_info = textscan(fid,'%f%s%s%s%s%f','Delimiter',',','HeaderLines',1);

if ismac
    % Code to run on Mac platform   
    patients_info = readtable('/Users/b3057108/NCLOneDrive/OneDrive - Newcastle University/Dataset/SleepKnn/patient details.csv');
    datafiles = dir('/Users/b3057108/NCLOneDrive/OneDrive - Newcastle University/Dataset/SleepKnn/*.mat');
    file_divider = '/';
elseif isunix
    % Code to run on Linux platform
elseif ispc
    % Code to run on Windows platform
    %onedrive = getenv('OneDrive');
    onedrive_path = 'E:\NCLOneDrive\OneDrive - Newcastle University\Dataset\SleepKnn';
    data_path = 'E:\NCLOneDrive\OneDrive - Newcastle University\Dataset\SleepKnn\*.mat';
    datafiles=dir('E:\NCLOneDrive\OneDrive - Newcastle University\Dataset\SleepKnn\*.mat');
    %patients_info = readtable('.\Dataset\patient details.csv');
    patients_info = readtable('E:\NCLOneDrive\OneDrive - Newcastle University\Dataset\SleepKnn\patient_details.csv');
    file_divider = '\';
else
    disp('Platform not supported')
end


groundtruth = []; % the ground truth for ever data points,
patient_unique_list = []; % finally should be a unique value list. 
pat_id2_ground = []; %patient ID to dataindex
%% loading dataset and put them into three sets
for i=1:length(datafiles)
    [~, f] = fileparts(datafiles(i).name);
    new_f_name = convertCharsToStrings(f);
    %new_f_name = extractBetween(f,5,length(f));
    patient_ID = extractBetween(f,13,14);
    patient_unique_list = [patient_unique_list, patient_ID];
end
patient_unique_list = unique(patient_unique_list); %set the patient list to unique  
test_pat_ID = '01';

Xtrain=[];Ytrain=[];
Xtest=[];Ytest=[];

for i=1:length(datafiles)
    [~, f] = fileparts(datafiles(i).name);
    new_f_name = convertCharsToStrings(f);
    patient_ID = extractBetween(f,13,14);   
    load([datafiles(i).folder,file_divider,datafiles(i).name]); 
    disorder_type = patients_info(patients_info.id == str2num(cell2mat(patient_ID)),{'SleepDisorderType'});
    % encode sleep disorder: 1 = short, 2 = normal, 3 = long
    disorder_type = disorder_type.SleepDisorderType(1,1);
    switch cell2mat(disorder_type)
        case "short"
            type = 1.0;
        case "normal"
            type = 2.0;
        case "long"
            type = 3.0;
    end    
    tmp_y = type * ones(length(y), 1);  
    if strcmp(patient_ID,test_pat_ID) % if this is the test data then add them into the test list
        Ytest = cat(1,Ytest,tmp_y);
        Xtest = cat(1,Xtest,x);
        %tmp_pat_id2_ground = patient_ID * ones(length(y),1);
        %pat_id2_ground = [pat_id2_ground:tmp_pat_id2_ground];
    else 
        Ytrain = cat(1,Ytrain,tmp_y);
        Xtrain = cat(1,Xtrain,x);
    end    
end

%% segment train and test

train_set = 1:50; % set the train set
test_set = 51:55; % set the test set

