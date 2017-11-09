% Set the experiment parameters for the test script
%% load feature
partition_name = 'Random';  %'Random';
fname = [dataset_name '_HistLBP' num2str(num_patch) 'Patch'];
 try
     load([dropbox_folder '/feature/' fname]);
 catch 
     error('No such type of feature precomputed.');
 end
% %% picking the useful features
% New appearance feature format
if num_patch == 341
    Feature = sparse(double(Feature));
else
    Feature = single(Feature);
end
AlgoOption.doPCA = 0;  % flag for PCA preprocessing
%% load dataset partition
load([dropbox_folder '/feature/' dataset_name '_Partition_' partition_name '.mat']);
load([dropbox_folder '/dataset/' dataset_name '_Images.mat'], 'gID', 'camID');

%%
% The number of test times with the same train/test partition.
% In each test, the gallery and prob set partion is randomly divided.
num_itr =10; 
np_ratio =10; % The ratio of number of negative and positive pairs. 
AlgoOption.name = algoname;
AlgoOption.func = algoname; 
AlgoOption.npratio = np_ratio; % negative to positive pair ratio
AlgoOption.beta =3;  % different algorithm have different meaning
AlgoOption.d =40; % projection dimension
AlgoOption.epsilon =1e-4;
AlgoOption.lambda =0;
AlgoOption.w = [];
AlgoOption.dataname = fname;
AlgoOption.partitionname = partition_name;
AlgoOption.num_itr=num_itr;
AlgoOption.npratio =0; % npratio is not required.
AlgoOption.beta =0.0025;
AlgoOption.d =100;
AlgoOption.LocalScalingNeighbor =6; % local scaling affinity matrix parameter.
AlgoOption.num_itr= 10;
        
        %%
AlgoOption.Nw = 0; % 0--use all within class samples
AlgoOption.Nb = 12;
AlgoOption.d1 = 30;
% customize in different case
switch  algoname
    case {'LFDA'}
        AlgoOption.npratio =0; % npratio is not required.
        AlgoOption.beta =0.0025;
        AlgoOption.d =100;
        AlgoOption.LocalScalingNeighbor =6; % local scaling affinity matrix parameter.
        AlgoOption.num_itr= 10;
        
        %%
        AlgoOption.Nw = 0; % 0--use all within class samples
        AlgoOption.Nb = 12;
        AlgoOption.d1 = 30;
%       AlgoOption.beta = 0.01;
        %%

    case {'MFA'}
        AlgoOption.Nw = 0; % 0--use all within class samples
        AlgoOption.Nb = 12;
        AlgoOption.d = 50;
        AlgoOption.beta = 0.01;

end


