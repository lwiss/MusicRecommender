close all; 
clear all;
clc;
% This script takes a sparse matrix and removes the full zero columns and
% the full zero rows

splitData;

[D,N]=size(Ytrain_new);
fprintf ('Ytrain_new : %dx%d\n',D,N);
Ytrain_new_clean=full(Ytrain_new);
artists_popularity=sum(Ytrain_new,1);% we find the indexes of artists that have no count 
I=find(artists_popularity==0);
Ytrain_new_clean(:,I)=[];% remove these artists
[Dnew,Nnew]=size(Ytrain_new_clean);
fprintf ('Ytrain_new_clean : %dx%d\n',Dnew,Nnew);
hist(Ytrain_new_clean(Ytrain_new_clean~=0),20);
% make the transformation 
% in our case it will be log10(X+1) where we add the one to avoid the
% evaluation of log10 at null values 
Ytrain_transformed=Ytrain_new_clean+1;
Ytrain_transformed=log10(Ytrain_transformed);
figure 
hist(Ytrain_transformed(Ytrain_transformed~=0),20);
%normalize the data and store it 
y_mu=mean(Ytrain_transformed(Ytrain_transformed~=0));
y_std=std(Ytrain_transformed(Ytrain_transformed~=0));
Ytrain_norm=(Ytrain_transformed((Ytrain_transformed~=0))-y_mu)./y_std;

figure 
hist(Ytrain_norm(Ytrain_norm~=0),20);

