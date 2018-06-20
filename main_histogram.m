% Draw the histograms of the cluster sizes when the initialzied cluster
% number is set to be 50, 100, and 1000. 
% 2015-11-4 10:39:41

%     SLIC: a whole brain parcellation toolbox
%     Copyright (C) 2016 Jing Wang
%
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
%
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
%
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.

% clear,clc;

load sInfo.mat;

figure;
stat=[];
count=0;
for method={'MSC_mean','MSC_twolevel','MKSC','SLIC_mean','SLIC_twolevel'}
    method=method{1,1};
    for cK=[50,100,1000]
        count=count+1;
        tmp=[];
        for iPart=1:nPart
            for iRep=1:nRep
                nii=load_untouch_nii(sprintf('%s_parc/K%d_part%d_rep%d.nii',method,cK,iPart,iRep));
                img=nii.img;
                img=img(:);
                img(img==0)=[];
                tab=tabulate(img);
                tmp=[tmp;tab(:,2)]; % store the cluster sizes
            end
        end
        tmp(tmp==0)=[];
        subplot(5,3,count);
        h=histfit(tmp,30);
        
        [mu,sigma]=normfit(tmp);
        stat=[stat;mu,sigma,max(tmp)];
    end
end

% scale
pos=get(gcf,'Position');
set(gcf,'Position',[pos(1),pos(2),pos(3)*1.6,pos(4)*2.2]);
