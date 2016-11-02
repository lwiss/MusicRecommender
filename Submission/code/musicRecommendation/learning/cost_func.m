function RMSE = cost_func( X, U, A, lambda,nu_i,na_j)
%COST_FUNC computes the RMSE
% TO DO     Write a detailed documentation
    n=nnz(X);
    [i,j,x]=find(X); % finds the indexes of nonzero elements of X and their corresponding vals
    X_pred = U'*A;
    subL_emp=zeros(1,length(i));
    parfor k=1:length(i)
      subL_emp(k)  =(x(k)-X_pred(i(k),j(k)))^2;
    end 
    L_emp=sum(subL_emp)/n;
    normU=sum(U.^2);
    normA=sum(A.^2);
    normU=sum(nu_i.*normU);
    normA=sum(na_j.*normA);
    
    RMSE=sqrt(L_emp + lambda*(normU+normA));
    
end

