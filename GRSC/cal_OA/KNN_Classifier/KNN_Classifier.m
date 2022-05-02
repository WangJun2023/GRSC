function [OA,MA,Kappa,test_SL,predict_label] = KNN_Classifier(Dataset, band_set)

[train_X,train_labels,test_X,test_labels,test_SL] = randdivide(Dataset);
test_size = size(test_labels, 1);
C = max(test_labels);
bs_train_X = train_X(:, band_set);
bs_test_X = test_X(:, band_set);

mdl = fitcknn(bs_train_X, train_labels, 'NumNeighbors',5, 'Standardize',1);
predict_label = predict(mdl,bs_test_X);
OA = 0;
cmat = confusionmat(test_labels, predict_label);
for i = 1 : size(predict_label, 1)
    if predict_label(i) == test_labels(i)
        OA = OA + 1;
    end
end
OA = OA / size(predict_label, 1);
sum_accu = 0;
for i = 1 : C
    sum_accu = sum_accu + cmat(i, i) / sum(cmat(i, :), 2);
end
MA = sum_accu / C;
Pe = 0;
for i = 1 : C
    Pe = Pe + cmat(i, :) * cmat(:, i);
end
Pe = Pe / (test_size*test_size);
Kappa = (OA - Pe) / (1 - Pe);

end

