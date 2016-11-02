% This script estimates the test RMSE 
close all;
clear all;
clc;

load songTrain;

MAX_ITER=100; %maximum number of iterations 
K=10; % #of folds used for cross validation 
% These 2 parameters are fixed by the cross validation procedure before we come to testing 
lambda_star=0.1; 
Nf_star = 30;


[idx,Nk]= K_fold_indexSplit(Ytrain,K); % prepare the indexes to determine the test set and the train set
subRMSE=zeros(4,K);

for kk=1:K
    % get the different data sets (train/test, weak/strong )
    [Ytest_strong,Ytest_weak,Ytrain_new, Gtrain_new, Gstrong] = ...
                                    K_fold_dataSplit(Ytrain,Gtrain,idx,kk,Nk);
    %% compute the prediction with naive mean approach
    Y_pred_strong=strong_gen_naive_mean_median(Ytrain_new,1); 
    subRMSE(1,kk)=cost_func_strongWF_testing(Ytest_strong,Y_pred_strong);
    
    %% compute the prediction naive meadian approach
    Y_pred_strong=strong_gen_naive_mean_median(Ytrain_new,2);  
    subRMSE(2,kk)=cost_func_strongWF_testing(Ytest_strong,Y_pred_strong);
    
    %% compute the prediction using mean approach and friendship information
    Y_pred_strong = MeanAllUsers(Ytrain_new, Ytest_strong, GStrong, 1)  ; 
    subRMSE(3,kk)=cost_func_testing(Ytest_strong,Y_pred_strong);
   
    %% compute the prediction using meadian approach and freindship information
    Y_pred_strong = MeanAllUsers(Ytrain_new, Ytest_strong, GStrong, 2)  ;
    subRMSE(4,kk)=cost_func_testing(Ytest_strong,Y_pred_strong);

end

figure 
boxplot(subRMSE');
xlabel 'Approach'
ylabel 'Error'