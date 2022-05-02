clear all
clc
dataset_names = {'Indian_Pines', 'KSC', 'Botswana','Salinas', 'Pavia_University'};
classifier_names = {'KNN', 'LDA','SVM','KSRC'};
svm_para = {'-c 5000.000000 -g 0.500000 -m 500 -t 2 -q',...
    '-c 10000.000000 -g 16.000000 -m 500 -t 2 -q',...
    '-c 10000 -g 0.5 -m 500 -t 2 -q',...
    '-c 100 -g 16 -m 500 -t 2 -q',...
    '-c 100 -g 4 -m 500 -t 2 -q',...
    };
train_ratio = [0.1, 0.1, 0.1, 0.1, 0.1];
SuperpixelNum = [165, 186, 180, 103, 155];
ResSavePath = 'result/';
warning off;

for dataset_id = 1
    Dataset = get_data(dataset_names{dataset_id});
    Dataset.svm_para = svm_para{1, dataset_id};
    Dataset.train_ratio = train_ratio(dataset_id);
    nC = SuperpixelNum(dataset_id);
    for classifier_id = 1
        [OA, MA, Kappa] = GRSC(Dataset,classifier_names{classifier_id},nC);
        resFile = [ResSavePath dataset_names{dataset_id},'-',num2str(nC),'-',...
            num2str(train_ratio(dataset_id)),'-',classifier_names{classifier_id},'.mat'];    
        save(resFile, 'OA', 'MA', 'Kappa');
    end
end