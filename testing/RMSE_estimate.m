% This script estimates the test RMSE 
close all;
clear all;
clc;

load songTrain;

MAX_ITER=100; %maximum number of iterations 
K=10; % #of folds used for cross validation 
% These 2 parameters are fixed by the cross validation procedure before we come to testing 
lambda_star=0.04; 
Nf_star = 50;


[idx,Nk]= K_fold_indexSplit(Ytrain,K); % prepare the indexes to determine the test set and the train set
subRMSE=zeros(1,K);

for kk=1:K
    % get the different data sets (train/test, weak/strong )
    [Ytest_strong,Ytest_weak,Ytrain_new, Gtrain_new, Gstrong] = ...
                                    K_fold_dataSplit(Ytrain,Gtrain,idx,kk,Nk);                        
    %% train the model:
    % i-cleaning data + ii-transformations + iii-normalisation
    [Ytrain_norm, I, y_mu,y_std] = cleaning_data_for_testing(Ytrain_new);
    % iv-training 
    %[~,U,A,nu_i,na_j]=ALS_estimate(Ytrain_norm,lambda_star,Nf_star,MAX_ITER);
    [Y_pred]=mean_estimate(Ytrain_norm);
    %% Make use of clustering to adjusts predictions
%     [responsabilitiesUser MuUsers]=kmeansDemo(U,Nf_star,3);
%     for i=1:size(U,2)
%         U(:,i)=U(:,i)+ MuUsers(responsabilitiesUser(i));
%     end
%     [responsabilitiesArtists MuArtists]= kmeansDemo(A,Nf_star,4);
%     for i=1:size(A,2)
%         A(:,i)=A(:,i) + MuArtists(responsabilitiesArtists(i));
%     end
    %% inverse transformation
    % now prepare for prediction get rid of the data processing we made
    % before learning the model :
    %Y_pred= U'*A; % compute the prediction for the known users-artisrs
    Y_pred=Y_pred*y_std+y_mu; % denormalize 
    Y_pred=ceil(10.^(Y_pred))-1; % the inverse transformation
    n_users=size(Y_pred,1); 
    Y_pred=insertrows(Y_pred',zeros(length(I),n_users),(I-(1:1:length(I))));% we put back the artists we removed earlier.
    Y_pred=Y_pred';
    Y_pred=ceil(Y_pred);

    %% compute the error
    % compute the RMSE for the weak generalization
    % IMPORTANT we should not predict for those artist we didn't trained on! OR DO WE? 
    subRMSE(1,kk) = cost_func_testing(Ytest_weak,Y_pred);
    %% plotting some information
    [i,j,s]=find(Ytest_weak);
    s_pred=zeros(length(i),1);
    for k=1:length(i)
        s_pred(k)=Y_pred(i(k),j(k));
    end
    figure
    scatter(s,s_pred);
    xlabel('Ytest wek');
    ylabel('Y pred');
    disp 'end of this iteration'
    
end
figure 
boxplot(subRMSE(1,:));
title 'Yweak';