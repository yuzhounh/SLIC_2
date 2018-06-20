% Preparations for parcellation. 
% 2018-6-19 15:37:19

%% Download the NIFTI toolbox and add it to path. 
% You might do it manually in case of error. 
url='http://www.mathworks.com/matlabcentral/mlc-downloads/downloads/submissions/8797/versions/28/download/zip/NIfTI_20140122.zip';
filename='NIfTI_20140122.zip';
if ~exist(filename,'file')
    urlwrite(url,filename); % download the NIFTI toolbox, 0.42 MB
end
unzip('NIfTI_20140122.zip','NIfTI_20140122'); % uncompress the toolbox
addpath('NIfTI_20140122/'); % add to path

%% the subject ID
sFile=dir('data/sub*');
nSub=length(sFile);
sSub=zeros(nSub,1);
tic;
for iSub=1:nSub
    filename=sFile(iSub,1).name;
    cSub=str2num(filename(4:8));
    sSub(iSub,1)=cSub;
    perct(toc,iSub,nSub);
end

%% the initialized cluster numbers
sK=[50:50:1000];
nK=length(sK);

%% Divide the subjects into two equal groups randomly. 
nRep=3;   % this operation is repeated for 3 times 
nPart=2;  % divide the subjects in two groups

% rng(1);
tmp=[];
for iRep=1:nRep
    tmp=[tmp;randperm(40)];
end
tmp=tmp';

randset=tmp(1:floor(nSub/2),:);
save('randset_1.mat','randset');

randset=tmp(floor(nSub/2)+1:40,:);
save('randset_2.mat','randset');

%% number of parallel workers
import java.lang.*;
nCPU=Runtime.getRuntime.availableProcessors; % number of CPUs
nWorker=floor(nCPU*0.90); % use 90% CPUs

%% save some useful information
save('sInfo.mat','sSub','nSub','sK','nK','nRep','nPart','nWorker');

%% Generate a 3*3*3 cubic searchlight mask. 
r=1;
nvSL=(2*r+1)^3; % number of voxels in a searchlight
riSL=zeros(nvSL,3);
count=0; 
for i=-r:r
    for j=-r:r
        for k=-r:r
            count=count+1;
            riSL(count,:)=[i,j,k];
        end
    end
end
save('parc_searchlight.mat','riSL','nvSL');

%% Save some useful information of the graymatter mask.  
file_mask='graymatter.nii';
nii=load_untouch_nii(file_mask);
img_gray=double(nii.img);
msk_gray=img_gray~=0;
ind_gray=find(msk_gray);
num_gray=length(ind_gray);
siz=size(msk_gray);
save('parc_graymatter.mat','msk_gray','ind_gray','num_gray','siz');

%% The coordinates of the adjacent voxels. 
% This is determined by the graymatter mask and the searchlight. 
load('parc_graymatter.mat');
load('parc_searchlight.mat');

nM=num_gray;

% adjacency matrix
fprintf('Calculating the coordinates of the adjacent voxels.\n');
cav=zeros(nM,nvSL);
tic;
for iM=1:nM
    % subscript of a single index in graymatter
    [i,j,k]=ind2sub(siz,ind_gray(iM));
    
    % searchlight constraint
    ix=riSL+repmat([i,j,k],nvSL,1);
    
    % box constraint
    tmp=all(ix>=ones(nvSL,3),2) & all(ix<=repmat(siz,nvSL,1),2);
    ix=ix(tmp,:);
    
    % single index
    % for voxels within the union of the searchlight and the box
    index=sub2ind(siz,ix(:,1),ix(:,2),ix(:,3));
    
    % mask constraint
    % convert the index in 3D space to that in the mask
    [tmp,index]=ismember(index,ind_gray);
    index=index(tmp);
    ix=ix(tmp,:);
    
    % save the coordinates of the adjacent voxels, cav
    cav(iM,1:length(index))=index';
    
    perct(toc,iM,nM,20);
end

% the binary format of cav
fprintf('Calculating the binary format of CAV.\n');
n=size(cav,1);
cavb=sparse(n,n);
tic;
for i=1:n
    tmp=cav(i,:);
    tmp(tmp==0)=[];
    cavb(i,tmp)=1;
    perct(toc,i,n,20);
end

save('parc_cavb.mat','cav','cavb');