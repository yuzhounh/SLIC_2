function mean_eigen(iPart,iRep)
% Extract features from the mean weight matrix by Ncut.
% 2016-5-28 17:06:25

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

tic;

load('parc_graymatter.mat');
load(sprintf('mean_weight/part%d_rep%d.mat',iPart,iRep));

K0=1000;
[EV,EDD]=Ncut_eigen(W,K0);  

time=toc/3600;
save(sprintf('mean_eigen/part%d_rep%d.mat',iPart,iRep),'EV','EDD','time');
fprintf('Time to calculate eigenvectors: %0.2f hours. \n',time);
