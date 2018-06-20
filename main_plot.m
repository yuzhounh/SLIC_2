% Plot the results of the evaluation metrics. 
% 2015-10-29 15:03:08

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

% actual cluster number
num=[];
for method={'MSC_mean','MSC_twolevel','MKSC','SLIC_mean','SLIC_twolevel'}
    method=method{1,1};
    tmp=zeros(nK,nPart,nRep);
    for iK=1:nK
        cK=sK(iK);
        for iPart=1:nPart
            for iRep=1:nRep
                load(sprintf('%s_parc/K%d_part%d_rep%d.mat',method,cK,iPart,iRep));
                tmp(iK,iPart,iRep)=K;
            end
        end
    end
    num=[num,mean(mean(tmp,3),2)];
end

% spatial discontiguity index
sdi=[];
for method={'MSC_mean','MSC_twolevel','MKSC','SLIC_mean','SLIC_twolevel'}
    method=method{1,1};
    tmp=zeros(nK,nPart,nRep);
    for iK=1:nK
        cK=sK(iK);
        for iPart=1:nPart
            for iRep=1:nRep
                load(sprintf('%s_sdi/K%d_part%d_rep%d.mat',method,cK,iPart,iRep));
                tmp(iK,iPart,iRep)=discontiguity;
            end
        end
    end
    sdi=[sdi,mean(mean(tmp,3),2)];
end

% homogeneity
hom=[];
for method={'MSC_mean','MSC_twolevel','MKSC','SLIC_mean','SLIC_twolevel'}
    method=method{1,1};
    tmp=zeros(nK,nPart,nRep);
    for iK=1:nK
        cK=sK(iK);
        for iPart=1:nPart
            for iRep=1:nRep
                load(sprintf('%s_homogeneity/K%d_part%d_rep%d.mat',method,cK,iPart,iRep));
                tmp(iK,iPart,iRep)=homogeneity;
            end
        end
    end
    hom=[hom,mean(mean(tmp,3),2)];
end

% dice
dic=[];
for method={'MSC_mean','MSC_twolevel','MKSC','SLIC_mean','SLIC_twolevel'}
    method=method{1,1};
    tmp=zeros(nK,nRep);
    for iK=1:nK
        cK=sK(iK);
        for iRep=1:nRep
            load(sprintf('%s_dice/K%d_rep%d.mat',method,cK,iRep));
            tmp(iK,iRep)=dice;
        end
    end
    dic=[dic,mean(tmp,2)];
end

% dice_sub
dic_sub=[];
for method={'MSC_mean','MSC_twolevel','MKSC','SLIC_mean','SLIC_twolevel'}
    method=method{1,1};
    tmp=zeros(nK,nRep);
    for iK=1:nK
        cK=sK(iK);
        for iRep=1:nRep
            load(sprintf('%s_dice_sub/K%d_rep%d.mat',method,cK,iRep));
            tmp(iK,iRep)=mean(dice(:));
        end
    end
    dic_sub=[dic_sub,mean(tmp,2)];
end

save('eval.mat','num','sdi','hom','dic','dic_sub');

load eval.mat;

load sK.mat;
sK=sK';

figure;

% Initialized cluster number
subplot(2,2,1);
plot(sK,num(:,1)-sK,'-o',...
    sK,num(:,2)-sK,'-x',...
    sK,num(:,3)-sK,'-+',...
    sK,num(:,4)-sK,'-*',...
    sK,num(:,5)-sK,'-s');
hold on;
plot(sK,zeros(size(sK)),'-k');
ylim([-225,50]);
xlabel('Initialized cluster number');
ylabel('Difference');
legend('MSC mean','MSC two-level','MKSC','SLIC mean','SLIC two-level','location','southwest');

% Spatial discontiguity index
% figure;
% plot(num(:,1),sdi(:,1),'-o',...
%     num(:,2),sdi(:,2),'-x',...
%     num(:,3),sdi(:,3),'-+',...
%     num(:,4),sdi(:,4),'-*',...
%     num(:,5),sdi(:,5),'-s');
% % ylim([0,5]);
% xlabel('K');
% ylabel('Spatial discontiguity index');
% legend('MSC mean','MSC two-level','MKSC','SLIC mean','SLIC two-level','location','northwest');

% Homogeneity
subplot(2,2,2);
plot(num(:,1),hom(:,1),'-o',...
    num(:,2),hom(:,2),'-x',...
    num(:,3),hom(:,3),'-+',...
    num(:,4),hom(:,4),'-*',...
    num(:,5),hom(:,5),'-s');
ylim([0.38,0.77]);
xlabel('K');
ylabel('Homogeneity');
legend('MSC mean','MSC two-level','MKSC','SLIC mean','SLIC two-level','location','southeast');

% Dice
subplot(2,2,3);
plot(num(:,1),dic(:,1),'-o',...
    num(:,2),dic(:,2),'-x',...
    num(:,3),dic(:,3),'-+',...
    num(:,4),dic(:,4),'-*',...
    num(:,5),dic(:,5),'-s');
ylim([0.35,1]);
xlabel('K');
ylabel('Dice');
legend('MSC mean','MSC two-level','MKSC','SLIC mean','SLIC two-level','location','northeast');

% Dice
subplot(2,2,4);
plot(num(:,1),dic_sub(:,1),'-o',...
    num(:,2),dic_sub(:,2),'-x',...
    num(:,3),dic_sub(:,3),'-+',...
    num(:,4),dic_sub(:,4),'-*',...
    num(:,5),dic_sub(:,5),'-s');
ylim([0.2,1]);
xlabel('K');
ylabel('Dice');
legend('MSC mean','MSC two-level','MKSC','SLIC mean','SLIC two-level','location','southwest');

% scale
pos=get(gcf,'Position');
scale=0.8;
set(gcf,'Position',[pos(1),pos(2),pos(3)*scale*2,pos(4)*scale*2]);