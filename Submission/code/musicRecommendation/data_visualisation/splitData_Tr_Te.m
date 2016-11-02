function [ YTr,YTe ] = splitData_Tr_Te( Y )
%SPLITDATA_TR_TE splits a data set into a train set (Tr) and a test set (Te) 


% Test data for weak generalization (for testing)
% Keep 5 entries per existing artist as test data
[D, N] = size(Y);
numD = 5; % number of users held out per artist (To be tuned)
dd = [];
nn = [];
yy = [];
for n = 1:N
    On = find(Y(:,n)~=0);
    if length(On)>10
        ind = unidrnd(length(On),numD,1); % choose some for testing
        d = On(ind);
        dd = [dd; d];
        nn = [nn; n*ones(numD,1)];
        yy = [yy; Y(d,n)];
    end
end
YTe = sparse(dd,nn,yy,D,N);
YTr=Y;
YTr(sub2ind([D N], dd, nn)) = 0;
end

