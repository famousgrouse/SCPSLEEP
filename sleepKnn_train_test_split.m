clear;clc;
%get the environment variable for the dataset folder
%% read patient dataset
%fid  = fopen('.\Dataset\patient details.csv');
%patients_info = textscan(fid,'%f%s%s%s%s%f','Delimiter',',','HeaderLines',1);
savedmat = 'E:\NCLOneDrive\OneDrive - Newcastle University\Dataset\SleepKnn\Pilot Data\pilot.mat';
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



patient_unique_list = []; % finally should be a unique value list. 
pat_id2_ground = []; %patient ID to dataindex
%% loading dataset and put them into three sets
for i=1:length(datafiles)
    [~, f] = fileparts(datafiles(i).name);
    new_f_name = convertCharsToStrings(f);
    %new_f_name = extractBetween(f,5,length(f));
    patient_ID = extractBetween(f,13,14);
    patient_ID = str2num(cell2mat(patient_ID));
    patient_unique_list = [patient_unique_list, patient_ID];
end
patient_unique_list = unique(patient_unique_list); %set the patient list to unique  
test_pat_ID = '01';
dataset_x= []; groundtruth = []; % the ground truth for ever data points,
Xtrain={};Ytrain={};
Xtest={};Ytest={};
k = 0;
for i=1:length(datafiles)
    [~, f] = fileparts(datafiles(i).name);
    new_f_name = convertCharsToStrings(f);
    patient_ID = extractBetween(f,13,14);   
    load([datafiles(i).folder,file_divider,datafiles(i).name]); 
    patient_ID = str2num(cell2mat(patient_ID));
    disorder_type = patients_info(patients_info.id == patient_ID,{'SleepDisorderType'});
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
    tmp_y = type * ones(length(y), 1);%build up current patient's ground truth  
    dataset_x =cat(1,dataset_x,x); 
    groundtruth = cat(1,groundtruth,tmp_y);
    tmp_pat_id2_ground = patient_ID * ones(length(y),1);
    pat_id2_ground = cat(1,pat_id2_ground,tmp_pat_id2_ground);
        
end
%% the following code is for test, so only one subject's data to be tested 
k=19;
tmp_test_id = patient_unique_list(3); % get the test patient id
tmp_idx_test  = find(pat_id2_ground == tmp_test_id); % get all index from dataset
Xtest = dataset_x(tmp_idx_test,:);
Ytest = groundtruth(tmp_idx_test,:);
tmp_idx_train = find(pat_id2_ground ~= tmp_test_id);
Xtrain = dataset_x(tmp_idx_train,:);
Ytrain = groundtruth(tmp_idx_train,:); 
[idx, dist] = knnsearch(Xtrain,Xtest,'k',k,'Distance', 'correlation');


% segment train and test
% for i = 1:length(patient_unique_list)
%     tmp_test_id = patient_unique_list(i); % get the test patient id
%     tmp_idx_test  = find(pat_id2_ground == test_id); % get all index from dataset
%     tmp_Xtest = dataset_x(tmp_idx_test,:);
%     tmp_Ytest = groundtruth(tmp_idx_test,:);
%     tmp_idx_train = find(pat_id2_ground ~= test_id);
%     tmp_Xtrain = dataset_x(tmp_idx_train,:);
%     tmp_Ytrain = groundtruth(tmp_idx_train,:); 
% end