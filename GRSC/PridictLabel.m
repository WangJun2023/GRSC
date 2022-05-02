function idx = PridictLabel(T,K)

nCluster = K ;
Z = ( abs(T) + abs(T') ) / 2 ;
idx = clu_ncut(Z,nCluster) ;
% for j = 1 : rep
% idx = clu_ncut(Z,nCluster) ;
% acc = compacc(idx,gnd); 
% accAvg = accAvg+acc;
% end
% accAvg = accAvg/rep;

end