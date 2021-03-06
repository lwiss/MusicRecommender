function [Y_norm] = cleaning_data(Y)
    % removes the unecessary columns 
    % makes the appropriate transformation 
    % then normalizes the data 


    Y_clean=Y;
    artists_popularity=sum(Y_clean,1);% we find the indexes of artists that have no count 
%     I=find(artists_popularity==0);
%     Y_clean(:,I)=[];% remove these artists
%     [Dnew,Nnew]=size(Y_clean);
%    fprintf ('Ytrain_new_clean : %dx%d\n',Dnew,Nnew);
    figure ;
    subplot(1,2,1);
    hist(Y_clean(Y_clean~=0),20);
    title 'Distribution of Ytrain';
    xlabel 'Listening count'
    
    % make the transformation 
    % in our case it will be log10(X+1) where we add the one to avoid the
    % evaluation of log10 at null values 
    Y_transformed=Y_clean+1;
    Y_transformed=log10(Y_transformed);
    subplot(1,2,2);
    %figure ;
    hist(Y_transformed(Y_transformed~=0),20);
    title 'Distribution of log10(Ytrain)';
    xlabel 'Listening count'
    % normalize the data
%     [i,j,s]=find(Y_transformed);
%     y_mu=mean(s);
%     y_std=std(s);
%     ss=(s-y_mu)/y_std;
%     Y_norm=sparse(i,j,ss);
% 
%     figure 
%     hist(Y_norm(Y_norm~=0),20);
%     title 'hist Ynorm';
end 

