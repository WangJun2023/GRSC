function [idx] = clu_ncut(L,K)
% this routine groups the data X into K subspaces by NCut
% inputs:
%       L -- an N*N affinity matrix, N is the number of data points
%       K -- the number of subpaces (i.e., clusters)
L = (L + L')/2;
D = diag(1./sqrt(sum(L,2)));
L = D*L*D;
[U,S,V] = svd(L);

V = U(:,1:K);
V = D*V;

stream = RandStream.getGlobalStream;
reset(stream);
% idx = kmeans(V,K,'emptyaction','singleton','replicates',20,'display','off');
[idx, ~, ~, ~] = kmeans(V, K,'maxiter',100,'replicates',50,'emptyaction','singleton');
idx = idx';