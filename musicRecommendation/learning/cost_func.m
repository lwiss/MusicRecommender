function RMSE = cost_func( X, U, A, lambda)
%COST_FUNC computes the RMSE
    [D N]=size(X);
    n=nnz(X);
    [i,j,x]=find(X); % finds the indexes of nonzero elements of X and their corresponding vals
    
    MSE= sum((x-U(:,i)'*A(:,j)).^2)/n;
    RMSE=sqrt(MSE);
end

