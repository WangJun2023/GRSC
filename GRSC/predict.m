function [Y] = predict(Z,k)
Y =[];
[dim,num] = size(Z);
for i = 1 : dim
    temp = Z(i,:);
    vc(i) = sqrt((temp*temp'+eps));
end
[~,idx] = sort(vc, 'descend');
Y = idx(1:k);
end

