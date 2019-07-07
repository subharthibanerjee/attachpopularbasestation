function [fsq, psq] = createFileSeq(nF, nodes)
% create a file sequence that are in base stations
% inputs,
% nF: number of files
% nodes: number of nodes
% outputs,
% fsq: file sequence
% psq: probability sequence

    charst = 65; % this is the ASCII code for character 'A'
    nSeq = nF^nodes; % number of sequence
    % same thing for different base
    codeSeq = dec2base(0 : nSeq - 1, nF, nodes); 
    
    fsq = codeSeq;
    
    % please understand this loop
    % this changes the file to be stored in each base station
    for i = 0 : nF - 1
        fsq(codeSeq(:) == num2str(i)) = char(charst + i);
    end
    
    % creating probability seqeuence here
    psq = zeros(size(codeSeq));
    % let's create probabilty that their sum is 1
    
    p = rand(1, nF); % Start with nF random numbers that don't sum to 1.
    p = p / sum(p);  % Normalize so the sum is 1.
    % theSum = sum(p)  % Check to make sure.  Should be 1
    % check if the the sum = 1
    for i = 0 : nF - 1
        psq(codeSeq(:) == num2str(i)) = p(i + 1);
    end
end

