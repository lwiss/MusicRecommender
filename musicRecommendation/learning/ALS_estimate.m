function [RMSE_Tr,U,A,nu_i,na_j] = ALS_estimate(X,lambda,Nf,MAX_ITER)
% X a Gaussian normalized data set. X (DxN)
% lambda is the regualrization parameter. Must be fixed using CV
% Nf is the number of hidden features we want to extract. Fixed using CV
  
    N=size(X,2); % # of artists
    A=[mean(X) ; rand(Nf-1,N)]; % initialize A
    epsilon=10^-5; %stopping criterion 
    cost_func_old=0;
    L=zeros(1,MAX_ITER);

    for iter=1:MAX_ITER
        
        [U,nu_i]=updateU(X,A,lambda,Nf);
        
        [A,na_j]=updateA(X,U,lambda,Nf);
        
        L(iter)=cost_func(X,U,A,lambda,nu_i,na_j);
        
        if L(iter)-cost_func_old<epsilon
            fprintf('the algorithm has converged in %d iterations L=%d\n',iter,cost_func_old);
            break
        end
        cost_func_old=L(iter);
       % fprintf('cost function%d %d\n',iter,cost_func_old);

    end
    
    RMSE_Tr=L(iter);

end