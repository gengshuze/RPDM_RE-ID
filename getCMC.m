% distMat: N_gallery*N_probe distance matrix
% group1,group2: the labels of gallery and probe
% note that only Single-shot is supported
function CMC = getCMC(distMat,label_gallery,label_probe,Xview1_gallery,Xview2_probe)

n_gal=size(label_gallery,1);
n_prob=size(label_probe,1);
TrueTable=zeros(n_gal,n_prob);
TrueTable_train=repmat(label_gallery,[1 n_prob]);
TrueTable_test=repmat(label_probe',[n_gal 1]);
TrueTable=(TrueTable_train==TrueTable_test);

ER=[];
for rank=1:n_gal
    errorNum=0;
    for i=1:n_prob
        dis=distMat(:,i); 
        dis=distMat(:,i); 
        [~, index]=sort(distMat,'ascend');
        index=index(1:rank);
        
         figure(1);
        
         subplot(2,4,1);
         imshow(Xview2_probe{1,label_probe(i)}.img)
      
         subplot(2,4,mod(i,8)+1);
         imshow(Xview1_gallery{1,label_gallery(index)}.img)
        if sum(TrueTable(index,i))==0
            errorNum=errorNum+1;
        end
    end
    ER=[ER errorNum/n_prob];
end
CMC = 1 - ER;
end