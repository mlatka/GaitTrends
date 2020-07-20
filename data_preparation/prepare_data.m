clc, clear, close all
% This script loads Dingwell’s MAT-file and calculates piecewise linear MARS
% trends.  The calculations are performed for a given treadmill speed (SPD)
% and gait parameter (attributeNumber) The output file contains:
% original series, MARS series, MARS residuals, time stamps,
% MARS models, MARS knot indices, and values at knots.

% Before running the script,  please set: speed (SPD) and attribute (SL/ST/SS).
% By default the variable generateFigures is set to true so that the time
% series and their MARS trends are plotted for all subjects. 
% Please ensure that you have added ARESLab folder (in libs/ folder) 
% to MATLAB path. 

SPD = 1; % 1 - 100, 2 - 110, 3 - 90, 4 - 120, 5 - 80 [%PWS]
attributeNumber = 1; % 1 - SL, 2 - ST, 3 - SS
generateFigures = true;


dataDir = '../data/original_Dingwell_data/';
addpath('../utils/');
fileList = dir(dataDir);
fileList = fileList(~[fileList.isdir]);

switch attributeNumber
    case 1
        param = 'Ln';
    case 2
        param = 'Tn';
    case 3
        param = 'Sn';
    otherwise
        error('Error. attributeNumber must an integer between 1 and 3.')
end

% MARS params
params = aresparams2('useMinSpan',-1,'useEndSpan',-1,'cubic',false,...
         'c',2,'threshold',1e-3,'maxFuncs',50);

residualsAll = {};
trendsAll  = {};
seriesAll  = {};
timestampsAll = {};
modelsAll  = {};
infosAll  = {};
knotIndicesAll = {};
valuesAtKnotAll = {};
        
for i = 1 : length(fileList)
    
    inputFileName = strcat(dataDir,fileList(i).name);
    load(inputFileName);

    % choose right data according to SPD
    switch SPD
        case 1
            data1 = SPD1TR1;
            data2 = SPD1TR2;
        case 2
            data1 = SPD2TR1;
            data2 = SPD2TR2;
        case 3
            data1 = SPD3TR1;
            data2 = SPD3TR2;
        case 4
            data1 = SPD4TR1;
            data2 = SPD4TR2;
        case 5
            data1 = SPD5TR1;
            data2 = SPD5TR2;
        otherwise
            error('Error. SPD must be an integer between 1 and 5.')
    end
    
    % trial 1
    strTrial = '1';
    
    % perform calculations for trial 1
    if length(data1(:,1)) > 1

        % cumulatie ST to obtain time stamps
        X = cumsum(data1(:,2))-data1(1,2);
        Y = data1(:,attributeNumber);

        % buildi MARS model using ARESLab
        model = aresbuild(X,Y,params);
        % generate trends
        predY = arespredict(model,X);
        % generate residuals (noise)
        detrendedY = Y - predY;

        residualsAll{end+1} = detrendedY;
        trendsAll{end+1} = predY;
        seriesAll{end+1} = Y;
        timestampsAll{end+1} = X;
        modelsAll{end+1} = model;
        infosAll{end+1} = strcat(fileList(i).name,'/trial',strTrial);

        % find MARS knots
        knotSites = sort(cell2mat(model.knotsites));
        knotIndices = zeros(1,length(knotSites));

        for k = 1 : length(knotSites)
            for j = 1 : length(X)
                if (knotSites(k) == X(j))
					knotIndices(k) = j;
					break;
                 end
            end

        end

        valuesAtKnot = [];

        if(knotSites > 0)
            knotIndices = [1 knotIndices];
            knotSites = [1; knotSites];
            valuesAtKnot = predY(knotIndices);
        end

        knotIndicesAll{end+1} = knotIndices;
        valuesAtKnotAll{end+1} = valuesAtKnot;


        if(generateFigures)
			plotTitle = strcat('Y',num2str(i),{'SPD'}, num2str(SPD), ...
				{'trial'}, strTrial);
			fig = figure;
			plot(X,Y,'LineWidth',2); hold on;
			plot(X,predY,'r','LineWidth',2); 
			plot(X(knotIndices), predY(knotIndices),'go',...
                'MarkerSize',8,'LineWidth',2);
			title(plotTitle,'FontSize', 20);
			xlim([min(X) max(X)]);
			xlabel('time [s]','FontSize', 18);
			ylabel(param,'FontSize', 18);
			grid on;
			set(gca,'FontWeight','bold','FontSize', 13);
			set(gcf, 'PaperPositionMode', 'auto');
			hold off;    
        end

    end
        
    % trial 2
    strTrial = '2';
    
    % perform calculations for trial 1
	if length(data2(:,1)) > 1

        % cumulate ST to obtain time series
		X = cumsum(data2(:,2))-data2(1,2);
		Y = data2(:,attributeNumber);
		
		% build MARS model using ARESLab
        model = aresbuild(X,Y,params);
        % generate trends
        predY = arespredict(model,X);
        % generate residuals (noise)
		detrendedY = Y - predY;
		
		residualsAll{end+1} = detrendedY;
		trendsAll{end+1} = predY;
		seriesAll{end+1} = Y;
		timestampsAll{end+1} = X;
		modelsAll{end+1} = model;
		infosAll{end+1} = strcat(fileList(i).name,'/trial',strTrial);
		
		% find MARS knots
        knotSites = sort(cell2mat(model.knotsites));
		knotIndices = zeros(1,length(knotSites));
		
		for k = 1 : length(knotSites)
			for j = 1 : length(X)
				if (knotSites(k) == X(j))
					knotIndices(k) = j;
					break;
				 end
			end

		end
		
		valuesAtKnot = [];
		
		if(knotSites > 0)
			knotIndices = [1 knotIndices];
			knotSites = [1; knotSites];
			valuesAtKnot = predY(knotIndices);
		end
		
		knotIndicesAll{end+1} = knotIndices;
		valuesAtKnotAll{end+1} = valuesAtKnot;
		
		if(generateFigures)
			plotTitle = strcat('Y',num2str(i),{'SPD'}, num2str(SPD), ...
				{'trial'}, strTrial);
			fig = figure;
			plot(X,Y,'LineWidth',2); hold on;
			plot(X,predY,'r','LineWidth',2); 
			plot(X(knotIndices), predY(knotIndices),'go',...
                'MarkerSize',8,'LineWidth',2);
			title(plotTitle,'FontSize', 20);
			xlim([min(X) max(X)]);
			xlabel('time [s]','FontSize', 18);
			ylabel(param,'FontSize', 18);
			grid on;
			set(gca,'FontWeight','bold','FontSize', 13);
			set(gcf, 'PaperPositionMode', 'auto');
			hold off;    
         end  

	end


end


% save data

outputDir = '../data/mat_data/';
file = strcat(outputDir,param,'_SPD',num2str(SPD),'.mat');

save(file,'residualsAll','trendsAll','seriesAll','timestampsAll',...
      'modelsAll','infosAll','knotIndicesAll','valuesAtKnotAll');
  
disp(strcat('Data saved to: ',file));