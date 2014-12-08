function [U,nu_i] = updateU(X, A, lambda,Nf)
% updates the matrix Z (NxM) which in our case corresponds to the artist
% matrix.
% nf = M=number of hidden features we want to extract
% X (DxN)is training matrix in our case it is the users,artists matrix 
% A (N) is fixed and correspond to the artist matrix 
    D=size(X,1);
    lamI = lambda * eye(Nf);
    U = zeros(Nf,D);
    U = single(U);
    nu_i=zeros(1,D);
    parfor i = 1:D
        artists = find(X(i,:));
        nu_i(i)=length(artists);
        Ai = A(:, artists);
        vector = Ai * full(X(i,artists))';
        matrix = Ai * Ai' + nu_i(i) * lamI;
        res = matrix \ vector;
        U(:, i) = res;
    end
end