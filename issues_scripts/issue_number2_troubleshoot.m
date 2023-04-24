% Testes realizados no Ubuntu, compatibilizar os caminhos com o windows.

cd /home/paulo/Documents/PauloPosDoc/Pos-Doc % pasta com o repositório research codes
addpath(genpath('ResearchCodes'))
pathtogit = '/home/paulo/Documents/PauloPosDoc/Pos-Doc/ResearchCodes';

% Arquivo a ser aberto com o pacote EEGLAB
addpath('/home/paulo/Documents/PauloPosDoc/Pos-Doc/BagOfCodesAndData/eeglab2021.1')
eeglab

% By inspection of the data in  ALLEEG structure the correction should be used.

% The structure of ALLEEG indicates that the number of trials is 291, not
% 300

ntrials = 291; fs = ALLEEG.srate; idnum = 1; tau = 13; correction = 0;
[data, channels, EEGtimes, EEGsignals] = to_datamatrix(ALLEEG, ntrials, fs, idnum, tau, 0);

GoalkeeperLab(data,pathtogit,ntrials,EEGsignals,fs,channels)

% Count the number of the events to see which is the problem.

occurrances = 0;
for c = 1:length(ALLEEG.event)
    if isequal('G  1', ALLEEG.event(c).type)
       occurrances = occurrances +1;
    end
end