function [input r ]= feature_ex(Input)


%% LBP start
num_patch = 6; %6, 14, 75, 341
     
% 
steps =flipud([4, 4; 8 8; 16 16; 48 21]); % set the moving step size of the region.
BBoxszs =flipud([8,8; 16 16; 32 32; 48 22]); % set the region size.
numP = [6 14 75 341]; 

 n8LBP_Mapping = getmapping(8,'u2');
 n16LBP_Mapping = getmapping(16,'u2');
%          
%% LBP end
input = struct;
input.group1 = Input.group1;
input.group2 = Input.group3;
input.group3 = Input.group2;
input.data = Input.data;

input.Xview1=[];
input.Xview2=[];
m=size(input.data{2,1},2);
    for f=1:m
                     
        img = input.data{2}{f}.img;
        I{f} =img;
        one_color_fv = CreateImageFeatureVector( img );

        %% LBP
         %image size check
         imgsizes = cellfun(@size, I, 'uni',0);
         imgsizes = cell2mat(imgsizes');
         imresize(img,[128 64]);
         I = cellfun(@(x) imresize(x,[128 64]),I,'uni',0);          
         LBP_Feature = HistLBP(I,16,BBoxszs(numP==num_patch,:),...
         steps(numP==num_patch,:),n8LBP_Mapping,n16LBP_Mapping);
            
         LBP_Feature=LBP_Feature(:,f);
         All_fv=[one_color_fv;LBP_Feature];
         input.Xview2=[input.Xview2,All_fv];
    end
    %%
            img = input.data{1}{1}.img;
            %indeces below 10 belong to camera B, and above 10 to camera A
            I{1} =img;
            one_color_fv = CreateImageFeatureVector( img );
            
       %% LBP
             imgsizes = cellfun(@size, I, 'uni',0);
             imgsizes = cell2mat(imgsizes');
             imresize(img,[128 64]);
%              Hog_feature=hog(img);
             I = cellfun(@(x) imresize(x,[128 64]),I,'uni',0);
             LBP_Feature =HistLBP(I,16,BBoxszs(numP==num_patch,:),...
             steps(numP==num_patch,:),n8LBP_Mapping,n16LBP_Mapping);
             LBP_Feature=LBP_Feature(:,1);
             All_fv=[one_color_fv;LBP_Feature];
             input.Xview1=[input.Xview1,All_fv];
        
                        %%
            
                r= pdm_reid(input);
            
        
            
end





