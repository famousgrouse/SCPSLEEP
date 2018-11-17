%% Benchmarks
% 1. we calculate the training dataset's PCA parameters
% 2. then we let each datapoint minus the mean of the all samples cross the
%    feature direction
clear;clc;
load('Benchmark');
[coeff, score, latent, tsquared, explained] = pca(double(Xtrain));
Xtrain_pca=bsxfun(@minus,double(Xtrain),mean(double(Xtrain),1))*coeff;
Xtest_pca=bsxfun(@minus,double(Xtest),mean(double(Xtest),1))*coeff;

%% EignFace + Nearest Neighbour
idx=knnsearch(Xtrain_pca,Xtest_pca);
acc_eignFace=sum(Ytest(idx)==Ytest)/length(idx); % calculate the accuracy

%% EignFace + SVM
SVM=svm_train(Ytrain, Xtrain_pca,'-s 0 -c 1 -t 1 -g 1 -r 1 -d 1 -q');
[Predict,acc_SVM,~]=svm_test(Ytest,Xtest_pca,SVM);