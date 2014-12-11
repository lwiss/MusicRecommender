function [Ln,r,Mu,distances] = kmeansUpdate(X, Mu)
% update r and Mu given X and Mu
% X is DxN data
% Mu is DxK mean vector
% r is 1xN responsibility vector, e.g. r = [1,2,1] for 2 clusters 3 data points
% Ln is 1xN minimum distance to its center for each point n

  % initialize
  K = size(Mu,2);
  [D,N] = size(X);
  r = zeros(1,N);
  Ln = zeros(1,N);
  
  % for each cluster, find error
  X=X';
  mu=Mu';
  XX=sum(X.*X,2); % gives N0x1 matrix , where N0 is the number of samples(rows) of X0
  mu_mu=sum(mu.*mu,2); % gives N1x1 matrix , where N1 is the number of samples(rows) of X1
  % distances is a NxK matrix where distances(n,k) is the distance between 
  % the n-th data point and the k-th cluster mean 
  distances= bsxfun(@plus, XX(:),mu_mu(:)')- 2*X*(mu');
  
  X=X'; % undo the transpose made above
  % find r
  [Ln1,r1]=min(distances,[],2);
  Ln=Ln1';
  r=r1';
  
  % find Mu for each k
  ind =[];
  for i= 1 : K
     ind= find(r==i);
     Mu(:,i) = mean (X(:,ind),2);
  end 