function idxCV= K_fold_indexSplit(Y,K)
% the data splits indexs  
% split data in K fold (we will only create indices)
% Input: Y the actual data set 
%        K the number of folds 
% Output: idxCv each row contains the indexes of the Strong test set 
    setSeed(1);
    [D,~] = size(Y);
    idx = randperm(D);
    Nk = floor(D/K);
    idxCV=zeros(K,Nk);
    for k = 1:K
        idxCV(k,:) = idx(1+(k-1)*Nk:k*Nk);
    end

end 