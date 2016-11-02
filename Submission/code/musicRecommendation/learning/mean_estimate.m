function [Y_pred]=mean_estimate(Y)
[D,N]=size(Y);

Y_pred=ones(D,N);
for k=1:D
  [~,~,s]= find(Y(k,:));
  Y_pred(k,:)=mean(s);  
end
Y_pred(isnan(Y_pred))=1;
Y_pred=ceil(Y_pred);
end