function A = updateA(X, U, lambda,Nf)
% updates the matrix A (NxM) which in our case corresponds to the artist
% matrix.
% Nf = number of hidden features we want to extract
% X (DxN)is training matrix in our case it is the users,artists matrix 
% U (DxM) is fixed and correspond to the users matrix 
    N=size(X,2);
    lamI = lambda * eye(Nf);
    A = zeros(Nf,N);
    A = single(A);
    for j = 1:N
        users = find(X(:,j));
        Uj = U(:, users);
        vector = Uj * full(X(users, j));
        matrix = Uj * Uj' + length(users) * lamI;
        res = matrix \ vector;
        A(:, j) = res;
    end
    %done
end
