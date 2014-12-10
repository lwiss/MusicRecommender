% This script estimates the test RMSE 
close all;
clear all;
clc;

load songTrain;

MAX_ITER=100; %maximum number of iterations 
K=10; % #of folds used for cross validation 
% These 2 parameters are fixed by the cross validation procedure before we come to testing 
lambda_star=35.83; 
Nf_star = 35;


idxTe= K_fold_indexSplit(Ytrain,K); % prepare the indexes to determine the test set and the train set
subRMSE=zeros(2,K);
for kk=1:K
    % get the different data sets (train/test, weak/strong )
    [Ytest_strong,Ytest_weak,Ytrain_new, Gtrain_new, Gstrong] = ...
                                    K_fold_dataSplit(Ytrain,Gtrain,idxTe,kk);
    % train the model:
    % i-cleaning data + transformations + normalisation
    [Ytrain_norm, I, y_mu,y_std] = cleaning_data_for_testing(Ytrain_new);
    % iv-training 
    [subRMSE(1,kk),U,A,nu_i,na_j]=ALS_estimate(Ytrain_norm,lambda_star,Nf_star,MAX_ITER);
    
    % now prepare for prediction get rid of the data processing we made
    % before learning the model :
    Y_pred= U'*A; % compute the prediction for the known users-artisrs
    Y_pred=(Y_pred+y_mu)*y_std; % denormalize 
    Y_pred=exp(Y_pred)-1; % the inverse transformation
    n_users=size(Y_pred,1); 
    Y_pred=insertrows(Y_pred',zeros(length(I),n_users),I);% we put back the artists we removed earlier.
    Y_pred=Y_pred';
    % compute the RMSE for the weak generalization
    % IMPORTANT we should not predict for those artist we didn't trained on! OR DO WE? 
    subRMSE(2,kk) = cost_func_testing(Ytest_weak,Y_pred);%,I);
    % compute the RMSE for the strong generalization 
    % Note that the prediction for strong relies on heuristic 
    
    
end
boxplot(subRMSE(2,:));