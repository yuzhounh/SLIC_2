% Evaluate the parcellation results.  
% 2016-12-13 11:10:274

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

% clear,clc,close all;

load sInfo.mat;

for method={'MSC_mean','MSC_twolevel','MKSC','SLIC_mean','SLIC_twolevel'}
    method=method{1,1};
    mkdir(sprintf('%s_sdi',method));
    mkdir(sprintf('%s_homogeneity',method));
    mkdir(sprintf('%s_dice',method));
    mkdir(sprintf('%s_dice_sub',method));
end

%% spaital discontiguity index
parc_parpool(nWorker);
parfor iK=1:nK
    for iRep=1:nRep
        for iPart=1:nPart
            for method={'MSC_mean','MSC_twolevel','MKSC','SLIC_mean','SLIC_twolevel'}
                method=method{1,1};
                eval_sdi(method,iK,iPart,iRep);
            end
        end
    end
end

%% homogeneity
parfor iK=1:nK
    for iRep=1:nRep
        for iPart=1:nPart
            for method={'MSC_mean','MSC_twolevel','MKSC','SLIC_mean','SLIC_twolevel'}
                method=method{1,1};
                eval_homogeneity(method,iK,iPart,iRep);
            end
        end
    end
end

%% dice
parfor iK=1:nK
    for iRep=1:nRep
        for method={'MSC_mean','MSC_twolevel','MKSC','SLIC_mean','SLIC_twolevel'}
            method=method{1,1};
            eval_dice(method,iK,iRep);
        end
    end
end

%% dice sub
parfor iK=1:nK
    for iRep=1:nRep
        for method={'MSC_mean','MSC_twolevel','MKSC','SLIC_mean','SLIC_twolevel'}
            method=method{1,1};
            eval_dice_sub(method,iK,iRep);
        end
    end
end
