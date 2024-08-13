% Description: takes the EEG from the list of subjects, build the data
% matrices and save them in a sigle struct to be used for analysing the
% behavioral data.

% HEADINGS
ntrials = 1500;
tree_num = 7;

path_to_files = 'C:\Users\Cabral\Documents\pos_doc\ResearchCodes\data_files\';

subjects = [[4:13] 51];
group_data = {};

aux = 1;
for s = subjects
    if s < 10
       aux_num = ['0' num2str(s) ];
    else
       aux_num = num2str(s);
    end
    if s > 50
        correction = 0;
    else
        correction = 1;
    end
    fname = ['EEG_subj' aux_num '_clean.mat'];
    load ([path_to_files fname], 'EEG')
    [data, ~, ~, ~] = to_datamatrix(EEG, ntrials, EEG.srate, aux, tree_num, correction);
    if size(data,1) > ntrials
        valid = ~(data(:,6) == 0);
        data = data(valid,:);
    end
    group_data{aux,1} = data; 
    aux = aux+1;    
end

data = [];
for a = 1:length(group_data)
   data = [data; group_data{a,1}]; 
end

save('C:\Users\Cabral\Documents\pos_doc\ResearchCodes\data_files\master_matrix', 'data')