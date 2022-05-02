function [Y] = SelectBandFromClusRes(lable, K, img)
% img: d*N
Y = [];
for i=1:K
    index = find(lable==i);
    tempdata = img(:,index);
    meandata = mean(tempdata,2);
    D = EuDist2(meandata',tempdata'); % 1*Nk
    [dumb idx] = sort(D,'ascend');
    Y = [Y,index(idx(1))];
end