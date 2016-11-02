% This script estimates the test RMSE 
close all;
clear all;
clc;

load songTrain;

MAX_ITER=100; %maximum number of iterations 
K=10; % #of folds used for cross validation 
% These 2 parameters are fixed by the cross validation procedure before we come to testing 
lambda_star=0.1; 
Nf_star = 3;


[idx,Nk]= K_fold_indexSplit(Ytrain,K); % prepare the indexes to determine the test set and the train set
subRMSE=zeros(1,K);
[Ytest_strong,Ytest_weak,Ytrain_new, Gtrain_new, Gstrong] = ...
                                    K_fold_dataSplit(Ytrain,Gtrain,idx,4,Nk);

                
    %% train the model:
    % i-cleaning data + ii-transformations + iii-normalisation
    [Ytrain_norm, I, y_mu,y_std] = cleaning_data_for_testing(Ytrain_new);
    % iv-training 
    [~,U,A,nu_i,na_j]=ALS_estimate(Ytrain_norm,lambda_star,Nf_star,MAX_ITER);
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

    %% data analysis
    % find 10 most representative artists per concept
    A=insertrows(A',zeros(length(I),Nf_star),(I-(1:1:length(I)))); % we put back the artist we have removed
    A=A';
    mostArtists=zeros(Nf_star,10);
    for i=1:Nf_star
        [sortedValues,sortIndex] = sort(abs(A(i,:)),'descend');
        mostArtists(i,:) = sortIndex(1:10);
        artistName(mostArtists(i,:))'
    end
    
%     %% use U and A to make clusters
%     [responsabilitiesUser MuUsers]=kmeansDemo(U(1:2,:),Nf_star-1,3);
%     figure;
%     [responsabilitiesArtists MuArtists]= kmeansDemo(A(1:2,:),Nf_star-1,3);

