% This script estimates the test RMSE 
close all;
clear all;
clc;

load songTrain;

MAX_ITER=10; %maximum number of iterations 
K=10; % #of folds used for cross validation 
% These 2 parameters are fixed by the cross validation procedure before we come to testing 
lambda_star=[0.02 0.06 0.08 0.1 ]; 
Nf_star = 2:2:25;

subRMSE = zeros(3,length(Nf_star));
[idx,Nk]= K_fold_indexSplit(Ytrain,K); % prepare the indexes to determine the test set and the train set

[Ytest_strong,Ytest_weak,Ytrain_new, Gtrain_new, Gstrong] = ...
                                    K_fold_dataSplit(Ytrain,Gtrain,idx,4,Nk); 
for ii=1:3
    for jj=1:length(Nf_star)                        
    %% train the model:
    % i-cleaning data + ii-transformations + iii-normalisation
    [Ytrain_norm, I, y_mu,y_std] = cleaning_data_for_testing(Ytrain_new);
    % iv-training 
    [~,U,A,nu_i,na_j]=ALS_estimate(Ytrain_norm,lambda_star(ii),Nf_star(jj),MAX_ITER);
    %[Y_pred]=mean_estimate(Ytrain_new);

    %% inverse transformation
    % now prepare for prediction get rid of the data processing we made
    % before learning the model :
    Y_pred= U'*A; % compute the prediction for the known users-artisrs
    Y_pred=Y_pred*y_std+y_mu; % denormalize 
    Y_pred=ceil(10.^(Y_pred))-1; % the inverse transformation
    n_users=size(Y_pred,1); 
    Y_pred=insertrows(Y_pred',zeros(length(I),n_users),(I-(1:1:length(I))));% we put back the artists we removed earlier.
    Y_pred=Y_pred';
    Y_pred=ceil(Y_pred);

    %% compute the error
    % compute the RMSE for the weak generalization
    % IMPORTANT we should not predict for those artist we didn't trained on! OR DO WE? 
    subRMSE(ii,jj) = cost_func_testing(Ytest_weak,Y_pred);
    end
end
figure 
plot (Nf_star,subRMSE(1,:),'b',Nf_star,subRMSE(2,:),'r--d',Nf_star,subRMSE(3,:),'k--+');
title 'Comparaison of the error for different lambda and Nf';
xlabel 'Number of features';
ylabel 'log(|Error|)';
