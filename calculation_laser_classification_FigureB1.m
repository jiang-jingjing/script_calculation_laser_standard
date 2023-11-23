%% Acessible Emission Limit (AEL) calculation following Flowchart B.1
% by jingjing Jiang, 2023.11.23

%% 5.4.3 Evaluation condition for extended sources
% wavelengths in the reginal hazard range (400 nm to 1400 nm)
% pulsed
% repetitively
%% choose class; select time base 4.3 e (class 1)
time_base = 100 % s, time base defined in 4.3 e) condition 2  
% emission duration to be considered for classification of laser products
% 2) 100 s for laser radiation of all wavelengths > 400 nm except for the
% cases listed in 1) and 3)
%% determine AELsingle (4.3f) 
PRF = 80e6 % Hz

t = 0.3 % exposure time s

% see Note 1: AELsingle is determined on the duration of a single pulse
t_single = 5e-12; % second, 5ps

% calculation for C6, from Table 9
ang_min = 1.5; % mrad
ang = 200 % estimated mrad

if t>0.25
    ang_max = 100; % for t>0.25  
elseif t <=0.25 && t> 625e-6 ;% 625 us - 0.25 s
    ang_max = 200 * t^0.5 ;% mrad
else % <625 us
    ang_max = 5; %mrad
end

if ang> ang_max
    C6 = ang_max / ang_min % for ang > ang_max
end
 
wv = 800 % max
C4 = 10 ^(0.002 * (wv - 700))

% from 4.3 f) repetitively pulsed or modulated lasers
%  Table 4: extented sources (retinal hazard region 400 - 1400 nm)
AELsingle = 7 * t_single ^0.75 * C4 * C6 % 700 to 1050 nm  J 

%% determine AELs.p.T, 4.3 f), requirement 2), see NOTE 1
T = time_base % chosen time base from previous condition
N_T = T ./ PRF % number of pulses in time T
AEL_T = 7 * T ^0.75 * C4 * C6
AELspT = AEL_T / N_T  % J
%%  table 2 Times below which pulse groups are summed
Ti = 5 * 1e-6; %s for wav 400 - 1050 nm


%% determine AELs.t.train
% Do multiple pulses occur within the period Ti -> yes
% determine AELspTrain, see Note 2
% the sinple suplse duration is changed to Ti, the new value of AELsingle
% is calculated.
t_single_updated = Ti
AELsingle_updated = 7 * t_single_updated ^0.75 * C4 * C6 % 700 to 1050 nm  J 
% the PRF is changed accordingly to determine the maxium allowed value of N
% see 4.3 f), the new value of AELsingle is divided by the number of
% original pulses contained in the period Ti before substituing the final
% value of AEL single in equation for AELs.p.train

numP_in_Ti = Ti * PRF
AELsingle_updated_divid = AELsingle_updated ./ numP_in_Ti  % J
C5 = 5 * numP_in_Ti^-0.25 % with a minimum value of C5 = 0,4.
AELspTrain = AELsingle_updated_divid * C5



%% choose smallest value of AELsingle, AELspTrain, AELspT 
AEL_min = min([AELsingle AELspT AELspTrain])  %

%% accessible emission level of a single pulse from our system
% < 0.5 mW at 725 nm
E_1s = 1; % mJ
EEL_sp = E_1s ./ PRF;
