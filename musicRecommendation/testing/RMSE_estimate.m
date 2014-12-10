% This script estimates the test RMSE 
close all;
clear all;
clc;

load songTrain;

K=10; % #of folds used for cross validation 
% These 2 parameters are fixed by the cross validation procedure before we come to testing 
lambda_star=35.83; 
Nf = 35;

Y=Ytrain;

idxTe= K_fold_indexSplit(Y,K); % prepare the indexes to determine the test set and the train set

for kk=1:K
    % get the different data sets (train / test, weak/strong )
    [Ytest_strong,Ytest_weak,Ytrain_new, Gtrain_new, Gstrong] = ...
                                    K_fold_dataSplit(Ytrain,Gtrain,idx,kk);
    % train the model:
    % i-cleaning data + transformations + normalisation
    
    % iv-training 
    
     
    
    % compute the RMSE for the weak generalization 
    
    % compute the RMSE for the strong generalization 
    
    
end
