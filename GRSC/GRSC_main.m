function [Z,S,obj] = GRSC_main(X, alpha, beta)
alpha = 10^alpha;
beta = 10^beta;

[Z, ~] = InitializeSIGs(X');

distX = L2_distance_1(X,X);
[distX1, idx] = sort(distX,2);

[dim,num] = size(X);
knn0 = 15;
rr = zeros(num,1);
for i = 1:num
    di = distX1(i,2:knn0+2);
    rr(i) = 0.5*(knn0*di(knn0+1)-sum(di(1:knn0)));
end
gamma = mean(rr);

flag = 1;
Q = zeros(dim);
iter = 0;
maxIter = 100;

[S, ~] = InitializeSIGs(X);
D = diag(sum(S));
L = D-S;

while flag
    iter = iter + 1;
    
    %% update Z
    for i = 1 : dim
        Z_i = Z(i,:);
        Q(i,i) = 0.5/sqrt((Z_i*Z_i'+ eps));
    end
    Z = inv(X*X'+ beta * X * L * X'+ alpha * Q)* X * X';
    Z = Z - diag(diag(Z));    
    Z = max(Z,eps);
    
    %% update S
    U = Z' * X;
    distU = L2_distance_1(U,U);
    S = zeros(num);
    for i = 1 : num
        idxa0 = idx(i,2:knn0+1);
        dui = distU(i,idxa0);
        dxi = distX(i,idxa0);
        ad = -(dxi+0.5*beta*dui)/(2*gamma);
        S(i,idxa0) = EProjSimplex_new(ad);
    end
    S = (S+S')/2;
    
    D = diag(sum(S));
    L = D-S;
    
    %% cal obj
    temp1 = norm(X'-X'*Z,'fro')^2;
    temp2 = sum(sum(L2_distance_1(X,X).* S))+ gamma * norm(S,'fro')^2;
    temp3 = alpha*L2_1(Z);
    temp4 = beta * trace(Z'*X*L*X'*Z);
    obj(iter) = temp1 + temp2 + temp3 + temp4;
    if (iter>2) && (abs((obj(iter-1)-obj(iter))/(obj(iter-1)))<1e-6 || iter>maxIter)
        flag = 0;
    end
    
end

end
