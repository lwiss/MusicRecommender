% This script estimates the test RMSE 
close all;
clear all;
clc;

load songTrain;
load songTestPairs;
MAX_ITER=100; %maximum number of iterations
% These 2 parameters are fixed by the cross validation procedure before we come to testing 
lambda_star=0.1; 
Nf_star = 3;
                        
%% train the model:
% i-cleaning data + ii-transformations + iii-normalisation
[Ytrain_norm, I, y_mu,y_std] = cleaning_data_for_testing(Ytrain);
% iv-training 
[~,U,A,nu_i,na_j]=ALS_estimate(Ytrain_norm,lambda_star,Nf_star,MAX_ITER);

%% inverse transformation
% now prepare for prediction get rid of the data processing we made
% before learning the model :
Y_pred= U'*A; % compute the prediction for the known users-artisrs
Y_pred=Y_pred*y_std+y_mu; % denormalize 
Y_pred=ceil(10.^(Y_pred))-1; % the inverse transformation
n_users=size(Y_pred,1); 
% we put back the artists we removed earlier.
Y_pred=insertrows(Y_pred',zeros(length(I),n_users),(I-(1:1:length(I))));
Y_pred=Y_pred';
Y_pred=ceil(Y_pred);

%% compute the prediction for the test set 
[D,N]=size(Ytest_weak_pairs);
[i,j,s]=find(Ytest_weak_pairs);
s_pred_weak=zeros(1,length(i));
for k=1:length(i)
    s_pred_weak(k)=Y_pred(i(k),j(k));
end
s_pred_weak(s_pred_weak==0) = randi(10,sum(s_pred_weak==0),1);
Ytest_weak_pred=sparse(i,j,s_pred_weak,D,N);


%% Strong test set
Y_pred_strong=strong_gen_naive_mean_median(Ytrain,2);

[D,N]=size(Ytest_strong_pairs);
[i,j,s]=find(Ytest_strong_pairs);
s_pred_strong=zeros(1,length(i));
for k=1:length(i)
    s_pred_strong(k)=Y_pred_strong(j(k));
end
Ytest_strong_pred=sparse(i,j,s_pred_strong,D,N);
    


%% Saving the test predictions
save('songPred', 'Ytest_strong_pred', 'Ytest_weak_pred');
