
%% this script is for debugging purpose 
% this script is to build up a test dataset by manually specify a test
% subject id
test_id = patient_unique_list(10); % get the test patient id
tmp_idx_test  = find(pat_id2_ground == test_id); % get all index from dataset
Xtest = dataset_x(tmp_idx_test,:);
Ytest = groundtruth(tmp_idx_test,:);
tmp_idx_train = find(pat_id2_ground ~= test_id);
Xtrain = dataset_x(tmp_idx_train,:);
Ytrain = groundtruth(tmp_idx_train,:); 
[idx, dist] = knnsearch(Xtrain,Xtest,'k',100,'Distance', 'correlation');