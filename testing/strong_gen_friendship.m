function [ yPredStrong ] = MeanAllUsers(Ytrain_new, Ytest_strong, GtestStrong, number)
%% In this function, we assign the mean of the artists for the new users

[users ~]= size(Ytrain_new);
[newUsers,artists]= size(Ytest_strong);
yPredStrong = zeros(newUsers,artists);
meanArtists= ones(artists,1);
    % For the values that we have to predict
    [I J nonNull]= find(Ytest_strong);
    for i=1:length(I)
        % Find user's friends
        [~,friends,~]= find(GtestStrong(I(i),1:users));
        % find user's friends' rates
        [~ ,~,values]= find(Ytrain_new(friends,J(i)));
        if (isnan(mean(values))==0)
            if number==1
                yPredStrong(I(i),J(i))= ceil(mean(values));
            else 
                yPredStrong(I(i),J(i))= ceil(median(values));
            end
        else
          yPredStrong(I(i),J(i))=1;  
        end
    
     end
    


end

