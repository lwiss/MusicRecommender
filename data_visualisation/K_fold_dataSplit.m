function [ Ytest_strong,Ytest_weak,Ytrain_new, Gtrain_new, Gstrong ] = K_fold_dataSplit(Y,G,idx,k,Nk)
%K_fold_dataSplit creates a test set and a train set
%   Input: Y is the data set 
%          idx is the indexes of the different test set that we want ot
%          create 
%          k the k-th fold we want to create
%          G the freindship matrix
%   Output: Ytest_strong mimics the unseen data (users that does not belong to the data base)
%           Ytest_weak mimics the unseen data for users in the database 
%           Ytrain_new the reamining data (will be used to train the model)

    idxTe = idx(1+(k-1)*Nk:k*Nk); % we take the k-th test indexes
    idxTr = idx;
    idxTr(1+(k-1)*Nk:k*Nk)=[]; % training indexes are the remaining ones
    Ytrain_new = Y(idxTr,:); 
    Ytest_strong = Y(idxTe,:);
    Gtrain_new = G(idxTr, idxTr);
    Gstrong = G(idxTe, [idxTr idxTe]);
    
    % Test data for weak generalization
    % Keep 5 entries per existing artist as test data
    [D, N] = size(Ytrain_new);
    numD = 5; % number of users held out per artist
    dd = [];
    nn = [];
    yy = [];
    for n = 1:N
        On = find(Ytrain_new(:,n)~=0);
        if length(On)>10
            ind = unidrnd(length(On),numD,1); % choose some for testing
            d = On(ind);
            dd = [dd; d];
            nn = [nn; n*ones(numD,1)];
            yy = [yy; Ytrain_new(d,n)];
        end
    end
    Ytest_weak = sparse(dd,nn,yy,D,N);
    Ytrain_new(sub2ind([D N], dd, nn)) = 0;

end

