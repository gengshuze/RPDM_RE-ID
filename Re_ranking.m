% test script 
% Set up computer environment
t1 = clock;
%% set up Experiment parameters
tic
Set_Exp_Parameter
disp('Data loading time is:')
eltime_dataLoading = toc
%%
rng('default');                                                             % Fix the random number generation for repeat results
for k =1:length(kname)                                                      % kernel for loop, select different kernel
    AlgoOption.kernel =kname{k};    
    if ~iscell(Feature)
        tmpF{1} = Feature;
        Feature = tmpF;
    end
    for c = 1:numel(Feature)
        if numel(gID)~=size(Feature{c},1)                                   % make sure the feature is N-by-d
            feature_set{c} = double(Feature{c})';
        else
            feature_set{c} = double(Feature{c});
        end                                                                  % Others apply L1 normalization                
            feature_set{c} = bsxfun(@times, feature_set{c}, 1./sum(feature_set{c},2));
            if ~strcmp(AlgoOption.kernel, 'chi2-rbf')
                feature_set{c} =feature_set{c}*100;
            end
     end
   end
%     %
     for idx_partition=1:length(Partition) % partition loop        
        display(['==============' kname{k} ' ' num2str(idx_partition),' set ============='])
        for iset = 1:2
           %% iset: 1. validation step, 2. testing step
            if iset == 1
                
              %% load validating data
                                                                            % inverse the training and testing set to validate the prior                     
                idx_train = Partition(idx_partition).idx_test ;
                idx_test = Partition(idx_partition).idx_train ;
                ix_train_neg_pair = Partition(idx_partition).idx_test_neg_pair; % negative pair index
                ix_train_pos_pair = Partition(idx_partition).idx_test_pos_pair; % positive pair index
                ix_test_gallery =Partition(idx_partition).ix_train_gallery;
            else
                %% papre training and testing data
                idx_train = Partition(idx_partition).idx_train ;
                idx_test = Partition(idx_partition).idx_test ;
                ix_train_neg_pair = Partition(idx_partition).idx_train_neg_pair;
                ix_train_pos_pair = Partition(idx_partition).idx_train_pos_pair;
                ix_test_gallery =Partition(idx_partition).ix_test_gallery;
            end       
            for c = 1:numel(feature_set)                    
                train{c} = feature_set{c}(idx_train,:); % training set
                test{c} = single(feature_set{c}(idx_test,:)); % test set                    
            end
            img=I;
            %% training step
            tic
            for c = 1:numel(train)                                                      
                        [algo_MFA{c}, V_MFA] = MFA(single(train{c}), gID(idx_train)', AlgoOption,img);
                        [algo_LFDA{c}, V_LFDA]= LFDA(single(train{c}),gID(idx_train)' ,AlgoOption,img);
             end
            disp('The training time is:')
            eltime_training = toc
          %% testing step                       
            [r, dis] = compute_rank2(algo_LFDA, train, test, ix_test_gallery, gID(idx_test),img,algo_MFA);
            disp('The testing time is:')
            eltime_testing = toc
            [a, b] = hist(r',1:316);
            % when the probe set is not the same as test gallery set, it will be
            % labeled as "-1"
            if min(min(double(ix_test_gallery)))<0
                a = cumsum(a)./repmat(sum(ix_test_gallery==-1,2)', size(a,1),1);
            else
                a = cumsum(a)./repmat(sum(ix_test_gallery==0,2)', size(a,1),1);
            end
            a = a';
            for itr =1: size(a,1)
                rr(itr,:)= [a(itr,1) a(itr,5) a(itr,10) a(itr,20) a(itr,25) a(itr,50)];
                display(['itration ' num2str(itr) ' Rank 1 5 10 20 25 50 accuracy ===>' num2str(rr(itr,:)) ' ====']);
            end
            display(num2str([mean(rr,1)]));
            %%
            aa=mean(a);
            aa=aa*100;
            aa=aa(1,1:20);
            plot(1:20,aa,'r->','LineWidth',3,'MarkerSize',18);
     end % partition loop    
    clear Method
        end

