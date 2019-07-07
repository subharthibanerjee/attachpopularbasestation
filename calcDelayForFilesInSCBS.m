function [indD, cF, binSq] = calcDelayForFilesInSCBS(flscbs, nUE, oUE, D)
% inputs
% flscbs : files can be "AA" or "AB" or "BA" or "BB"
% file string can be "AAA" if there are 3 BS and so on
% nUE: number of UEs requesting files
% oUE: send the indices of oUE (not used currently)

% output: individual and total delays for files stored in SCBSs
% indD:   Delay matrix correspoding to the UE
% cF:   cost Factor for files

%% this section generates the file sequence 
nSeq = 2 ^ nUE; % number of sequence is as shown based on nUE
binSq = dec2bin(0:nSeq - 1, nUE); % convert them in binseq
    
% now change bin Seq to file sequence
fileSq = binSq;
fileSq(binSq(:)=='0')='A'; 
fileSq(binSq(:)=='1')='B';

%% assigning probability values for files A and B
% i will create a probability matrix here
P.A = abs(rand(1));
P.B = 1 - P.A;


% now I don't know >0.5 will do anything

probSeq = zeros(size(binSq)); 
probSeq(binSq(:) == '0') = P.A; % assign probability values for file A
probSeq(binSq(:) == '1') = P.B; % assign probability values for file B

% finally get 2^nUE prob values 

% ========== you are proposing them as cost factor right???? ==============
% loop if you are having multiple UE


% multiply by column-wise -- see the dot there - means element-wise

disp("probability sequence below, please check")
probSeq
cF = probSeq(:, 1) .* probSeq(:, 2) .* probSeq(:, 3);
% you will see below when returning indD
% we will multiply the delay by cF


disp('file sequence successfully created and displayed below .....')
disp('Please check if the file sequence is correct')
fileSq
disp('Processing further on generated file sequence')

%% process delay on for file combinations in SCBS
% you can obviously make another function here 
% but for ease of understanding no more functions


% can you vectorize below for loop
% IT TAKES EXCESS TIME TO RUN DUAL LOOP
% below code runs on logic that you gave me 
% so do not change any of your logic
for i = 1 : nSeq
    for j = 1 : nUE
        switch(j)
            case 1
                % ue 1 connected to scbs1
                if (flscbs(1) == fileSq(i, j))
                    indD(i, j) = D(1, 1); % shorter delay scbs
                    fprintf("\nUE %d requests file %c connected to SCBS 1 having %c with delay %d\n", j,  fileSq(i, j), flscbs(1), indD(i, j));

                elseif (flscbs(1) ~= fileSq(i, j) )
                    indD(i, j) = D(1, 3); % larger delay mbs
                    fprintf("\nUE %d requests file %c connected to MBS, SCBS 1 having %c with delay %d\n", j, fileSq(i, j), flscbs(1), indD(i, j));
                end
            case 2
                
        
                % BECAUSE ue2 is connected to two bs
                % we accept the shorter delay one, as the delay is randomly chosen
                if (flscbs(2) == fileSq(i, j) && ...
                        flscbs(1) == fileSq(i, j))
                    d1 = D(2, 1);
                    d2 = D(2, 2);
                    [d, ind] = min([d1, d2]); % shorter delay scbs
                    indD(i, j) = d;
                    fprintf("\nUE %d requests file %c connected to SCBS %d having %c with delay %d\n", j, fileSq(i, j), ind, flscbs(ind), indD(i, j));

                elseif (flscbs(1) == fileSq(i, j))
                    indD(i, j) = D(2, 1); % scbs 1
                    fprintf("\nUE %d requests file %c connected to SCBS 1 having %c with delay %d\n", j, fileSq(i, j),flscbs(1),  indD(i, j));
                elseif (flscbs(2) == fileSq(i, j) )
                    indD(i, j) = D(2, 2); % scbs 2
                    fprintf("\nUE %d requests file %c connected to SCBS 2 having %c with delay %d\n", j, fileSq(i, j), flscbs(2), indD(i, j));
                else
                    indD(i, j) = D(2, 3); % mbs
                    fprintf("\nUE %d requests file %c connected to MBS, SCBS 1 has %c, SCBS has % c, with delay %d\n", j, ...
                        fileSq(i, j), flscbs(1), flscbs(2), indD(i, j));
                end
            case 3
                % ue 3 connected to scbs 2
                if (flscbs(2) == fileSq(i, j))
                    indD(i, j) = D(3, 2); % shorter delay scbs
                    fprintf("\nUE %d requests file %c connected to SCBS 2 having %c with delay %d\n", j, fileSq(i, j), flscbs(2),indD(i, j));


                elseif (flscbs(2) ~= fileSq(i, j))
                    indD(i, j) = D(3, 3); % larger delay mbs
                    fprintf("\nUE %d requests file %c connected to MBS, SCBS 2 having %c with delay %d\n", j, fileSq(i, j), flscbs(2), indD(i, j));
                end 
        
    end
    end

 
end
% returning the cost factor

cF = indD .* repmat(cF,1,nUE);
end

