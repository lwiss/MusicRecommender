
% Step 1 : Initialize matrix A by assigning the average count for that 
% artist as the first row, and small random numbers for the remaining entries.

cleaning_data;
fprintf 'ALS_estimate script\n';
MAX_ITER=10; % the maximum number of iterations to stop the algorithm even 
             % if it has not reached the stopping criterion 

lambda=1; % regularization term              
X=Ytrain_norm; % the training set
N_counts=nnz(X); % # of non zero elements of X
Nf=10; % # of features
N=size(X,2); % # of artists
D=size(X,1); % # of users

A=[mean(X) ; rand(Nf-1,N)]; % initialize A

% cost_func_old=0;
 L=zeros(1,MAX_ITER);

for iter=1:MAX_ITER
    iter
    U=updateU(X,A,lambda,Nf);
    
    A=updateA(X,U,lambda,Nf);
    
    %L(iter)=cost_func(X,U,A,lambda);
    %L(iter)
    
end