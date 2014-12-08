function RMSE = cost_func( X, U, A, lambda)
%COST_FUNC computes the RMSE
    [D N]=size(X);
    n=nnz(X);
    [i,j,x]=find(X); % finds the indexes of nonzero elements of X and their corresponding vals
    % to do : add nu_i and na_j to the regularization terms
    X_pred = U'*A;
    
    MSE=x-X_pred(i,j)
%     for k=1:length(i)
%       MSE(k)  =(x(k)-X_pred(i(k),j(k)))^2  
%       nu_i(k)=
%     end 
    
    RMSE=sqrt(sum(MSE));
end

