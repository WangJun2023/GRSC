function [res_OA, res_MA, res_Kappa] = GRSC(Dataset,classifier_type,nC)
img = Dataset.A;

[labels,~] = cubseg(img,nC);
labels = labels + 1;
idx = label2idx(labels);
X1 = (Dataset.X)';
[m,n]=size(X1);

par = 5;
opt.disp = 0;
X_temp = cell(1,nC);
for i = 1 : nC
    [r,c]=ind2sub([m,n],idx{i});
    X_temp{i} = X1(r,:); 
end
LX = LP(X_temp);
for num = 1 : nC
    LX(:,:,num) = (LX(:,:,num)+LX(:,:,num)')/2;
    [Hp, ~] = eigs(LX(:,:,num), par, 'la', opt);
    X(:,:,num) = Hp;
end
[W, H, L]=size(X);
X = reshape(X, W, H * L);
X = X./ repmat(sqrt(sum(X.^2, 2)),1, H * L);

BandK = 5 : 5 : 50;

alpha = [-6 : 2 : 6];
beta = [-6 : 2 : 6];

count = 1;
IE = Entrop(Dataset.X);

for ifi = 1 : length(alpha)
    for ise = 1 : length(beta)
        [Z,S,obj] = GRSC_main(X, alpha(ifi), beta(ise));
        fprintf('开始计算第 %d 个组合\n',count);
        for iBand = 1:length(BandK)
            K = BandK(iBand);
            CluRes = PridictLabel(Z,K);
            Y = [];
            for num_IE = 1 : K
                cluster_IE = find(CluRes == num_IE);
                [~,Y_IE] = max(IE(cluster_IE));
                Y(num_IE) = cluster_IE(Y_IE);
            end
            [acc,Classify_map] = test_bs_accu(Y, Dataset, classifier_type);
            OA(count,iBand) = acc.OA;
            MA(count,iBand) = acc.MA;
            Kappa(count,iBand) = acc.Kappa;
        end
        count = count + 1;
    end
end

res_OA = max(OA);
res_MA = max(MA);
res_Kappa = max(Kappa);

end

