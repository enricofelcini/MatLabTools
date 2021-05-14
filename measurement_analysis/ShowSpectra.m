function ShowSpectra(dataSets,tmpTitleFig,addIndex,addLabel)
% ShowSpectra     shows distributions recorded by SFM, QBM and GIM;
%                 it shows a 2x1 3D figure, with the distributions on the
%                   horizontal plane on the left and those on the vertical
%                   plane on the right;
%                 both raw data from monitors and total distributions can
%                   be plotted.
%                 NB: if you need to plot a subset... please give a proper
%                   subset of data as input!
%
% eg:
%      ShowSpectra(sumSFMData,"Run2-Carbonio",cyProgs,"cyProgs");
%
% input:
% - dataSets [float(Nfibers,nColumns,2(,nDataSets))]: array of data. See also
%   ParseSFMData and SumSpectra for more info;
% - tmpTitleFig [string]: title of plot. It will be used for both the
%   window and the plot title;
% - addIndex [float(nColumns-1), optional]: list of IDs to be shown;
%   it can be used to separate distribution by cyProg or cyCode;
% - addLabel [string, optional]: name of the y-axis;
%
% see also ParseSFMData and SumSpectra.

    fprintf("plotting data...\n");
    ff=figure('Name',LabelMe(tmpTitleFig),'NumberTitle','off');
    nDataSets=size(dataSets,2)-1;
    cm=colormap(parula(nDataSets));
    if ( ~exist('addIndex','var') )
        addIndex=1:nDataSets;
    end
    if ( ~exist('addLabel','var') )
        addLabel="ID";
    end
    
    % hor distribution
    subplot(1,2,1);
    for iSet=1:nDataSets
        plotSpectrum(dataSets(:,1,1),dataSets(:,1+iSet,1),addIndex(iSet),cm(iSet,:));
        hold on;
    end
    title("horizontal plane");
    grid on;
    xlabel("position [mm]");
    ylabel(LabelMe(addLabel));
    zlabel("Counts []");

    % ver distribution
    subplot(1,2,2);
    for iSet=1:nDataSets
        plotSpectrum(dataSets(:,1,2),dataSets(:,1+iSet,2),addIndex(iSet),cm(iSet,:));
        hold on;
    end
    title("vertical plane");
    grid on;
    xlabel("position [mm]");
    ylabel(LabelMe(addLabel));
    zlabel("Counts []");
    
    % global
    sgtitle(LabelMe(tmpTitleFig));
end

function plotSpectrum(xx,yy,iSet,color)
% plotSpectrum      function actually plotting a single distribution
%                   the distribut is plotted as a colored histogram in a 3D
%                   space, where the axes are:
%                   - X: independent var (e.g. fiber central positions);
%                   - Y: ID of the current distribution (e.g. cyProg);
%                   - Z: bin values;
% 
% input:
% - xx, yy [float(Nvalues)]: arrays of data (will be shown on the X and Z axis,
%   respectively);
%   NB: xx and yy must be row vectors, not column vectors!
% - iSet [integer]: index of the current data set (will be used as Y-coordinate);
% - color [float(3)]: RGB codification of color;
%
    plotX=xx;
    if ( size(plotX,2)== 1 )
        plotX=plotX';
    end
    plotY=yy;
    if ( size(plotY,2)== 1 )
        plotY=plotY';
    end
    % get non-zero values
    indices=(plotY~=0.0);
    plotX=plotX(indices);
    plotY=plotY(indices);
    nn=size(plotX,2);
    zz=iSet*ones(1,nn);
    fill3([plotX fliplr(plotX)],[zz zz],[plotY zeros(1,nn)],color,'FaceAlpha',0.3,'EdgeColor',color);
end


