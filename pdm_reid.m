function r=pdm_reid(input)
%% get training and testing samples
Xview1Test=input.Xview1;
Xview2Test=input.Xview2;
Xview1_gallery=input.data{1};
Xview2_probe=input.data{2};

groupTest1=input.group1;groupTest1=reshape(groupTest1,numel(groupTest1),1);
groupTest2=input.group2;groupTest2=reshape(groupTest2,numel(groupTest2),1);
%% train the PDM model

% methodName= 'PDM';
%  eval(['model=',methodName,'();']);
%   model.training(Xview1Train,Xview2Train,groupTrain1,groupTrain2);
 load('PMD.mat');
%% test the CMC
distMat = model.calDistMat(Xview1Test,Xview2Test);
[~, index]=sort(distMat,'ascend');
 r =  find(index == 1);
end