function RMSE = cost_func( X, U, A, lambda)
%COST_FUNC computes the RMSE
    [D N]=size(X);
    n=nnz(X);
    [i,j,x]=find(X); % finds the indexes of nonzero elements of X and their corresponding vals
    % to do : add nu_i and na_j to the regularization term 
    X_hat=U'*A;
    [i,j,x_hat]=find(X_hat);
    MSE=sum(x-x_hat)/n;
    
%     for k=1:length(i)
%       MSE(k)  =(x(k)-U(:,i(k))'*A(:,j(k))).^2  + ...
%                     lambda*(U(:,i(k))'*U(:,i(k))+A(:,j(k))'*A(:,j(k)));
%     end 
    
    RMSE=sqrt(sum(MSE));
end

