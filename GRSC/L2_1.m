function [A]=L2_1(U)
A=0;
[n,~]=size(U);
for i=1:n
    A=A+sqrt(U(i,:)*U(i,:)');
end
end