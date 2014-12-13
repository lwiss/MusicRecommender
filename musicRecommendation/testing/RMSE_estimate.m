% This script estimates the test RMSE 
close all;
clear all;
clc;

load songTrain;

MAX_ITER=100; %maximum number of iterations 
K=10; % #of folds used for cross validation 
% These 2 parameters are fixed by the cross validation procedure before we come to testing 
lambda_star=0.6; 
Nf_star = 35;


[idx,Nk]= K_fold_indexSplit(Ytrain,K); % prepare the indexes to determine the test set and the train set
subRMSE=zeros(2,K);
%%
for kk=1:K
    % get the different data sets (train/test, weak/strong )
    [Ytest_strong,Ytest_weak,Ytrain_new, Gtrain_new, Gstrong] = ...
                                    K_fold_dataSplit(Ytrain,Gtrain,idx,kk,Nk);
    % train the model:
    % i-cleaning data + transformations + normalisation
    [Ytrain_norm, I, y_mu,y_std] = cleaning_data_for_testing(Ytrain_new);
    % iv-training 
    [subRMSE(1,kk),U,A,nu_i,na_j]=ALS_estimate(Ytrain_norm,lambda_star,Nf_star,MAX_ITER);
    
%     [responsabilitiesUser MuUsers]=kmeansDemo(U,Nf_star,3);
%     for i=1:size(U,2)
%         U(:,i)=U(:,i)+ MuUsers(responsabilitiesUser(i));
%     end
    [responsabilitiesArtists MuArtists]= kmeansDemo(A,Nf_star,5);
    for i=1:size(A,2)
        A(:,i)=A(:,i) + MuArtists(responsabilitiesArtists(i));
    end
    % now prepare for prediction get rid of the data processing we made
    % before learning the model :
    Y_pred= U'*A; % compute the prediction for the known users-artisrs
    Y_pred=Y_pred*y_std+y_mu; % denormalize 
    Y_pred=10.^(Y_pred)-1; % the inverse transformation
    n_users=size(Y_pred,1); 
    Y_pred=insertrows(Y_pred',zeros(length(I),n_users),(I-(1:1:length(I))));% we put back the artists we removed earlier.
    Y_pred=Y_pred';
    % compute the RMSE for the weak generalization
    % IMPORTANT we should not predict for those artist we didn't trained on! OR DO WE? 
    subRMSE(2,kk) = cost_func_testing(Ytest_weak,Y_pred);%,I);
    % compute the RMSE for the strong generalization 
    % Note that the prediction for strong relies on heuristic 
    [i,j,s]=find(Ytest_weak);
    s_pred=zeros(length(i),1);
    
    
    for k=1:length(i)
        s_pred(k)=Y_pred(i(k),j(k));
    end
    threshold=1000;
    pred_reality_ratio=abs(s_pred-s);
    [Ioutliers, Joutliers, outliers]=find(pred_reality_ratio>=threshold);
    s_pred(Ioutliers)=[];
    s(Ioutliers)=[];
    
    artists_with_zeros_pred=find(s_pred==0);
    artists_with_zeros_pred=j(artists_with_zeros_pred);
    figure
    scatter(s,s_pred);
   % title ('mean test rmse %f',subRMSE(2,kk));
    xlabel('Ytest wek')
    ylabel('Y pred')
    disp 'end of this iteration'
end

figure 
boxplot(subRMSE(2,:));