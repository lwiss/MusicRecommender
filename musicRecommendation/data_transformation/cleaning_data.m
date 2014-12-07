close all; 
clear all;
clc;
% This script takes a sparse matrix and removes the full zero columns and
% the full zero rows

splitData;

[D,N]=size(Ytrain_new);
fprintf ('Ytrain_new : %dx%d\n',D,N);

artists_popularity=sum(Ytrain_new,1);% we find the indexes of artists that have no ocunt 
I=find(artists_popularity==0);
Ytrain_new_clean=Ytrain_new;
Ytrain_new_clean(:,I)=[];% remove these artists
[Dnew,Nnew]=size(Ytrain_new_clean);
fprintf ('Ytrain_new_clean : %dx%d\n',Dnew,Nnew);

% now we make a data transformation 
% here it will be a log10 transformation 
[i,j,s]=find(Ytrain_new_clean);
%Ytrain_transformed=sparse(i,j,log10(s),Dnew,Nnew);
% TO DO try different transformations
 Ytrain_transformed=sparse(i,j,sqrt(s),Dnew,Nnew);

% now we normalize the data 
ii=[];jj=[];ss=[];
for k = 1 : Dnew
    [~,j,s]=find(Ytrain_transformed(k,:));
    mu=mean(s);
    stdm=std(s);
    s=(s-mu)./stdm;
    %update the previous values
    ss=[ss;s(:)];
    jj=[jj;j(:)];
    ii=[ii;ones(length(j),1)*k];
    
end

Ytrain_norm=sparse(ii,jj,ss);



