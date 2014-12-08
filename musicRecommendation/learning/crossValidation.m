clear all; close all; clc;
% this script does the cross validation i.e fix the hyper parameters of the
% model 
% in our case the hyper parameters are 
% i- the regularization term
% ii- the number of features that we need to extract 



splitData_strong_weak_new; % load the data and make split it into 
% Ytrain_new the training set 
% Ytest_strong set (to test unseen users i.e that are not on the data base)
% Ytest_weak set 
MAX_ITER=100;
Ytrain_norm=cleaning_data(Ytrain_new); %clean only the actual train set

% now make cross valication on this set Ytrain_norm

Nf= linspace (2,100,20);
lambda= logspace(-2,2,20);
K=10; % # of folds
subRMSE=zeros(2,K); % 1st line stores the train RMSE and 2nd stores the test RMSE
meanRMSE_Te=zeros(length(Nf),length(lambda));
meanRMSE_Tr=zeros(length(Nf),length(lambda));
for i=1:length(Nf)
    for j=1: length(lambda)
        for k=1:K
            [YTr,YTe]=splitData_Tr_Te(Ytrain_norm);
            %learn the model for these hyper params in this sub fold 
            [subRMSE(1,k),U,A,nu_i,na_j]=ALS_estimate(YTr,lambda(j),Nf(i),MAX_ITER);
            %test the model for these hyper params in this sub fold 
            subRMSE(2,k)=cost_func(YTe,U,A,lambda(j),nu_i,na_j);
            
        end 
        meanRMSE_Tr(i,j)=mean(subRMSE(1,:));
        meanRMSE_Te(i,j)=mean(subRMSE(2,:));
    end
    
end 

[L_star,ind_star]=min(meanRMSE_Te(:));
[Nf_star,lambda_star]=ind2sub(length(Nf),length(lambda),ind_star);