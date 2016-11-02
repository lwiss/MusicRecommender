
%read data
% X = importdata('faithful.txt');
function [r, Mu] = kmeansDemo(X,Nf,K)

% data is DxN

% center data
%WRITE CODE TO CENTER THE DATA
X=bsxfun(@minus,X,mean(X,2)); % center the data 
X=bsxfun(@times,X,1./std(X,0,2));



% plot data
plot(X(1,:), X(2,:), 'ko', 'markersize', 5, 'markerfacecolor', 'k');
grid on;
%axis([-2.5 2.5 -2.5 2.5]);
%set(gca, 'xtick', [-2:2],'ytick', [-2:2])
fprintf('press any key to continue...');
pause;

% initialize
MuOld = randn(Nf,K);
%MuOld = [1 -1 0; -1 1 0];
K = size(MuOld,2); 
colors = {'r','b','g','c','k','m','y'};
maxIters = 10;
Lold=0;
epsilon=10^-6;
% iterate
for i = 1:maxIters
  % update R and Mu
  %COMPLETE THIS FUNCTION
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
  % visualize clusters
  hold off;
  plotClusters(X, r, MuOld, colors)
  pause(.5); 
  hold off;
  plotClusters(X, r, Mu, colors)
  pause(.5); 

  % new mean is the old mean now
  MuOld = Mu;
  Lold = L(i);
end
end
