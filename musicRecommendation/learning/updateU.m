function U = updateU(X, A, lambda,Nf)
% updates the matrix Z (NxM) which in our case corresponds to the artist
% matrix.
% nf = M=number of hidden features we want to extract
% X (DxN)is training matrix in our case it is the users,artists matrix 
% A (N) is fixed and correspond to the artist matrix 
    D=size(X,1);
    lamI = lambda * eye(Nf);
    U = zeros(Nf,D);
    U = single(U);
    for i = 1:D
        artists = find(X(i,:));
        Ai = A(:, artists);
        vector = Ai * full(X(i,artists))';
        matrix = Ai * Ai' + length(artists) * lamI;
        res = matrix \ vector;
        U(:, i) = res;
    end
    %done
end