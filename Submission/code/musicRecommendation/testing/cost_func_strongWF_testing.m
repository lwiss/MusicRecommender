function RMSE = cost_func_strongWF_testing( X,X_pred)
%COST_FUNC computes the RMSE for the strong generalization without using
%the freindship graph 
% TO DO     Write a detailed documentation
    n=nnz(X);
    [i,j,x]=find(X); 
    subL_emp=zeros(1,length(i));
    parfor k=1:length(i)
      subL_emp(k)  =abs(log(x(k))-log(X_pred(j(k))));
    end
    L_emp=sum(subL_emp)/n;
    RMSE=L_emp;
    
end

