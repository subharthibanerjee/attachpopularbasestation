function [indD, cF] = calcDelayForFilesInSCBSMult(flscbs,nF, D)
% inputs
% flscbs : files can be "AA" or "AB" or "BA" or "BB"
% file string can be "AAA" if there are 3 BS and so on
% nF: number of files
% D: the delay matrix

% output: individual and total delays for files stored in SCBSs
% indD:   Delay matrix correspoding to the UE
% cF:   cost Factor for files

%  ############### IMPORTANT ###########################
% =========================================================================
% lets first consider the delay matrix. What does it provide you?
% Obviosuly, the connection details. If UE and SCBS is not connected, then
% it shows a NAN value (right?). So we will be using delay matrix 
% exclusively.
% =========================================================================

% the code will be abstract so that you can simulate any number of files in
% cache and any number UEs (may it be overlapping)

%% this section generates the file sequence 

    
% now change bin Seq to file sequence and probabilty sequence
nUE = size(D, 1)% nUE is the number of rows in delay matrix
nodes = size(D, 2) % number of connecting nodes
[fileSq, probSeq] = createFileSeq(nF, nUE);

% IMPORTANT: please do not print your file sequence, but you can always
% debug to check if the file sequence is correct or the probability
% sequence


nSeq = size(fileSq, 1); % number of file requests

% multiply by column-wise -- see the dot there - means element-wise

cF = ones(size(probSeq(:, 1)));

for i = 1 : nUE 
    cF = cF .* probSeq(:, i);
end
% you will see below when returning indD
% we will multiply the delay by cF


disp('file sequence successfully created .......')


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
            % fot the cases of UE 1,5,7 they are connected to single SCBS
            case 1
                % ue 1 connected to scbs1
                if (flscbs(1) == fileSq(i, j))
                   indD(i, j) = D(j, 1); % shorter delay scbs
                    

                elseif (flscbs(1) ~= fileSq(i, j) )
                    indD(i, j) = D(j, nodes); % larger delay mbs
                    
                end
             case 5
                % ue 5 connected to scbs2
                if (flscbs(2) == fileSq(i, j))
                   indD(i, j) = D(j, 2); % shorter delay scbs
                    

                elseif (flscbs(2) ~= fileSq(i, j) )
                    indD(i, j) = D(j, nodes); % larger delay mbs
                    
                end
             case 7
                % ue 7 connected to scbs3
                if (flscbs(3) == fileSq(i, j))
                   indD(i, j) = D(j, 3); % shorter delay scbs
                    

                elseif (flscbs(3) ~= fileSq(i, j) )
                    indD(i, j) = D(j, nodes); % larger delay mbs
                    
                end
            case 2 
                
        
                % BECAUSE ue2 is connected to two bs 1 and 2
                % we accept the shorter delay one, as the delay is randomly chosen
                if (flscbs(1) == fileSq(i, j) && ...
                        flscbs(2) == fileSq(i, j))
                    d1 = D(j, 1);
                    d2 = D(j, 2);
                    [d, ind] = min([d1, d2]); % shorter delay scbs
                    indD(i, j) = d;
                    

                elseif (flscbs(1) == fileSq(i, j))
                    indD(i, j) = D(j, 1); % scbs 1
                   
                elseif (flscbs(2) == fileSq(i, j) )
                    indD(i, j) = D(j, 2); % scbs 2
                   
                else
                    indD(i, j) = D(j, nodes); % mbs
                   
                       
                end
                
           case 4 
                
        
                % BECAUSE ue4 is connected to two bs 1 and 3
                % we accept the shorter delay one, as the delay is randomly chosen
                if (flscbs(1) == fileSq(i, j) && ...
                        flscbs(3) == fileSq(i, j))
                    d1 = D(j, 1);
                    d2 = D(j, 3);
                    [d, ind] = min([d1, d2]); % shorter delay scbs
                    indD(i, j) = d;
                    

                elseif (flscbs(1) == fileSq(i, j))
                    indD(i, j) = D(j, 1); % scbs 1
                   
                elseif (flscbs(3) == fileSq(i, j) )
                    indD(i, j) = D(j, 3); % scbs 3
                   
                else
                    indD(i, j) = D(j, nodes); % mbs
                   
                       
                end
           case 6 
                
        
                % BECAUSE ue4 is connected to two bs 2 and 3
                % we accept the shorter delay one, as the delay is randomly chosen
                if (flscbs(2) == fileSq(i, j) && ...
                        flscbs(3) == fileSq(i, j))
                    d1 = D(j, 2);
                    d2 = D(j, 3);
                    [d, ind] = min([d1, d2]); % shorter delay scbs
                    indD(i, j) = d;
                    

                elseif (flscbs(2) == fileSq(i, j))
                    indD(i, j) = D(j, 2); % scbs 2
                   
                elseif (flscbs(3) == fileSq(i, j) )
                    indD(i, j) = D(j, 3); % scbs 3
                   
                else
                    indD(i, j) = D(j, nodes); % mbs
                   
                       
                end
                
                
           case 3 
                
        
                % BECAUSE ue3 is connected to three bs 1, 2 and 3
                % we accept the shorter delay one, as the delay is randomly chosen
                if (flscbs(2) == fileSq(i, j) && ...
                        flscbs(3) == fileSq(i, j) && flscbs(1) == fileSq(i, j))
                    d1 = D(j, 1);
                    d2 = D(j, 2);
                    d3 = D(j, 3);
                    [d, ind] = min([d1, d2, d3]); % shorter delay scbs
                    indD(i, j) = d;
                    
                elseif (flscbs(2) == fileSq(i, j) && ...
                        flscbs(3) == fileSq(i, j) && flscbs(1) ~= fileSq(i, j))
                    d1 = D(j, 2);
                    d2 = D(j, 3);
                    [d, ind] = min([d1, d2]); % shorter delay scbs
                    indD(i, j) = d;
                elseif (flscbs(1) == fileSq(i, j) && ...
                        flscbs(2) == fileSq(i, j) && flscbs(3) ~= fileSq(i, j))
                    d1 = D(j, 1);
                    d2 = D(j, 2);
                    [d, ind] = min([d1, d2]); % shorter delay scbs
                    indD(i, j) = d;
                elseif (flscbs(1) == fileSq(i, j) && ...
                        flscbs(3) == fileSq(i, j) && flscbs(2) ~= fileSq(i, j))
                    d1 = D(j, 1);
                    d2 = D(j, 3);
                    [d, ind] = min([d1, d2]); % shorter delay scbs
                    indD(i, j) = d;
                   
                elseif (flscbs(3) == fileSq(i, j) )
                    indD(i, j) = D(j, 3); % scbs 3
                elseif (flscbs(1) == fileSq(i, j) )
                    indD(i, j) = D(j, 1); % scbs 3
                elseif (flscbs(2) == fileSq(i, j) )
                    indD(i, j) = D(j, 2); % scbs 3
                   
                else
                    indD(i, j) = D(j, nodes); % mbs
                   
                       
                end
        
        end
     end

 
end
% returning the cost factor

cF = indD .* repmat(cF,1,nUE);
end

