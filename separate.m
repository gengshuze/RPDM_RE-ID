function [trainInd1,trainInd2,testInd1,testInd2] = separate(group1,group2)

labels = unique(group1);
nLabel = numel(labels);
rand_idx = randperm(nLabel);
trainInd1 = ismember(group1,labels(rand_idx(1:floor(nLabel/2))));
trainInd2 = ismember(group2,labels(rand_idx(1:floor(nLabel/2))));
testInd1 = ismember(group1,labels(rand_idx(floor(nLabel/2)+1:end)));
testInd2 = ismember(group2,labels(rand_idx(floor(nLabel/2)+1:end)));
end