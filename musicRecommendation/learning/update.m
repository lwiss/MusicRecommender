function result = update(Ytrain, U)
%M = # of features 
%
    lamI = lambda * eye(M);
    result = zeros(M,N); 
    result = single(result); 
    for m = 1:N
        users = find(Ytrain(:,m));
        Um = U(:, users);
        vector = Um * full(Ytrain(users, m)); 
        matrix = Um * Um' + locWtM(m) * lamI; 
        X = matrix \ vector;
        result(:, m) = X;
    end
        result = gather(darray(result));
end