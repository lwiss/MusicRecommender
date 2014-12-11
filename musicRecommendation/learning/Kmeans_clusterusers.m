function [ r,Mu ] = Kmeans_clusterusers( X,K )
  % K: # of clusters  
    [~,N]=size(X);
    X = X';
%     X=bsxfun(@minus,X,mean(X,2)); % center the data 
%     X=bsxfun(@times,X,1./std(X,0,2));
    
    % initialize
    MuOld =randn(N,K);

    maxIters = 100;
    Lold=0;
    epsilon=10^-6;
    % iterate
    for i = 1:maxIters
      % update R and Mu
      [Ln, r, Mu,distances] = kmeansUpdate(X,MuOld);
      % average distance over all n 
      L(i) = mean(Ln);
      fprintf('%d .4%f\n', i, L(i));

      % convergence
      %WRITE CODE FOR CONVERGENCE
       if (abs(Lold-L(i))<epsilon)
           break;
       end 
       Lold=L(i);


      % new mean is the old mean now
      MuOld = Mu;
      Lold = L(i);
    end



end

