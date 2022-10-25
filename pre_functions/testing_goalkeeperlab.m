%HomeCode
close all
home = '/home/paulo/Documents/PauloPosDoc/Pos-Doc/BagOfCodesAndData';
addpath(genpath(home))
load([home '/ExperimentData/ColetaINDCpilotoDownsampled/PreprocessedData/vol01sr1000.mat'])
load([home '/ExperimentData/ColetaINDCpilotoDownsampled/Technical Aspects/chanlocs.mat'])
fs = 1000;
ntrials = 1500;
data(:,6)= 1*ones(ntrials,1);
% [data, channels, EEGtimes, EEGsignals] = to_datamatrix(ALLEEG, ntrials,
% fs, 1, 7); not necessary after loading

GoalkeeperLab(data,[home '/Git'],ntrials,EEGsignals,fs,channels)
