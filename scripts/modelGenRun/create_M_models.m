%% this script for creating models for ishii data set
%% addPaths

% addpath(genpath('/Users/vikashpandey/git/CPLEX_Studio1251'));
% addpath(genpath('/Users/vikashpandey/git/FBA_Toolboxes'));
load('/Users/vikash/Desktop/REMI/data/fmodel.mat')
fff=fmodel;
storeModels={};
for mut_exp=2:8
    %% initialize varibales
    wt=1;
    mut=mut_exp;
    tarns_cut=0.1; % transcript cutoff
    up=.05;
    down=.05;
    
    %% This data from Elux2 paper
    load('/Users/vikash/Desktop/REMI/data/iJO1366.mat') % load genome scale model
    load('/Users/vikash/Desktop/REMI/data/test_expr.mat') % load expression data
    genes=expr{1};
    genes_data=expr{2};
    
    %% check FBA model
    % fmodel=iJO1366;
    % fmodel.rev=ones(numel(fmodel.rev),1);
    % fmodel=addUseVariablesDH(fmodel);
    % fmodel=addNetFluxVariablesNEW(fmodel);
    % sol=solveTFBAmodel(fmodel);
    % initialize FBAmodel with maximum flux
    
    load('/Users/vikash/Desktop/REMI/data/fmodel.mat')
    m_fmodel=fmodel;
    
        sol=solveTFBAmodel(fmodel);
        m_fmodel.var_lb(find(fmodel.f))=sol.val*0.8;
    
%     % find reaction and reaction ratios between two conditions
%     geneWT=nan(numel(fmodel.genes),1);
%     geneMUT=nan(numel(fmodel.genes),1);
%     for i=1:numel(fmodel.genes)
%         [~,ind]=ismember(fmodel.genes{i},genes);
%         if ind>0
%             geneWT(i)=genes_data(ind,wt);
%             geneMUT(i)=genes_data(ind,mut);
%         end
%     end
    
%     % calculate ratio (if transcrip label is too samll then we dont cal culate ratio)
%     ind1=find(geneWT(geneWT>tarns_cut));
%     ind2=find(geneMUT(geneMUT>tarns_cut));
%     indC=intersect(ind1,ind2); % common index
%     ratio=geneMUT(indC)./geneWT(indC);
%     tmpModel=createEnumModel(m_fmodel,m_fmodel,m_fmodel.genes(indC),ratio,up,down); % genes and ratio should be same length
%     
    % This piece of codes for adding relative metabolites data set
%     load('/Users/vikashpandey/Documents/MATLAB/EcoliRelative/GSEcoliRelData_ChangeLBUB.mat')
    tmpModel=m_fmodel;
    mutant=mut_exp-1;
    concWT=fff.Ishii.concData(:,8);
    concMUT=fff.Ishii.concData(:,mutant);
    ratio=concMUT./concWT;
    tmpModel.S=fff.S;
    tmpModel.mets=fff.mets;
    tmpModel.rxns=fff.rxns;
    tmpModel=createMetModel(tmpModel,fff.mets,ratio,up,down);
     % store models
    storeModels{end+1}=tmpModel;
end
% save('/Users/vikashpandey/Documents/MATLAB/EcoliRelative/RepeatMET/ThermoMet/onlyMET/iShiiModelThermoRelative.mat','storeModels')
% 
% %%


