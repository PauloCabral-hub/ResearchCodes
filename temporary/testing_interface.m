% Description: testing GoalkeeperLab functionalities

% Headings:
pathtogit = 'C:\Users\Cabral\Documents\pos_doc\ResearchCodes';
ntrials = 1500;
EEGsignals = [];
fs = 1024;
channels = [];
load('C:\Users\Cabral\Documents\pos_doc\ResearchCodes\data_files\master_matrix')

% Correction to be made
add_data = find(data(:,6) == 11,1);
data = data(1:add_data(1)-1,:);

% Body
GoalkeeperLab(data,pathtogit,ntrials,EEGsignals,fs,channels)