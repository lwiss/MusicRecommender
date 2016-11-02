function Y_pred=strong_gen_naive_mean_median(Y,number)
% Input Y : (DxN) the training matrix
% Output Y_pred a vector containing the average listening count for each
% artist 
[~,N]=size(Y);
Y_pred=zeros(1, N);
for k = 1: N
 [~,~,s]=find(Y(:,k)); 
 if (number==1)
    Y_pred(k)=mean(s);
 else 
    Y_pred(k)=median(s);
 end
end 
Y_pred(isnan(Y_pred))=1;
Y_pred=ceil(Y_pred);
end 