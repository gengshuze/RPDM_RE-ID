%% ## Demo Example
% To run our code just run_demo.m_ 	
% and you should see something like this:
%   Data loading time is:
% 
%   eltime_dataLoading =
% 
%     0.4845
% 
%   ==============chi2-rbf 1 set =============
%   begin MFA chi2-rbf
%   begin LFDA chi2-rbf
%   The training time is:
% 
%   eltime_training =
% 
%    14.6162
%      ...
%
clc
clear
warning off
dropbox_folder =  pwd;
addpath(genpath('Assistant Code'));
mkdir('feature');
% name of metric learning algorithm 
algoname = 'MTT';
% dataset name
dataset_name = 'VIPeR'; %{'VIPeR' 'iLIDS' '};
% kernel name
kname={'chi2-rbf'}; % {'linear', 'chi2', 'chi2-rbf'};
num_patch = 6; %6, 14, 75, 341
pcadim = 65; %[77 45 65 70];
n8LBP_Mapping = getmapping(8,'u2');
n16LBP_Mapping = getmapping(16,'u2');       

if ~exist(['feature/' dataset_name '_Partition_Random.mat'],'file')
    Set_Partition(dataset_name);
end
Re_ranking
