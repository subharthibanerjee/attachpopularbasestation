function [indD , cF]=calcDelay(flscbs, nUE, D)

%Here we have to use GrayCodes for generating sequence of requests ( but How??)
%in the first case in Helper Nodes these file are cached (flscbs) = "A","A","A"
% then the requests of Users are 0 0 0 0 0 0 0 ( A A A A A A A) :
%Prob= P.A * P.A* P.A * P.A * P.A * P.A * P.A =p^7
%P(A)=p
%in addition : the probability for this cacheplacement is P(AAA)
%cost function is define as value which is accounted by 2facors :
% Delay and probability delay(AAA) .*P(AAA) for each request


% now change  graySeq to file sequence 
fileSq = Seq;
fileSq(Seq(:) =='0')='A';
fileSq(Seq(:) =='1')='B';
fileSq(Seq(:) =='2')='C';

%Probabilities
P.A =abs(rand(1));
P.B =(1-P.A)/2;
P.C =(1-P.A)/2;

probSeq = zeros(size(Seq)); 
probSeq(Seq(:) == '0') = P.A; % assign probability values for file A
probSeq(Seq(:) == '1') = P.B; % assign probability values for file B
probSeq(Seq(:) == '2') = P.C; % assign probability values for file C


disp('probability sequence below, please check')
probSeq
cF = probSeq(:, 1) .* probSeq(:, 2) .* probSeq(:, 3) .* probSeq(:, 4) .* probSeq(:, 5) .* probSeq(:, 6) .* probSeq(:, 7) ;




for i=1: %NumberofSequenceOfFile %(for example here we set 3^7 (state space or number of request ))
    for j=1: nUE
       switch(i)
           
          case 1
                % ue 1 connected to scbs1
                if (flscbs(1) == fileSq(i, j))
                    indD(i, j) = D(1, 1); % shorter delay scbs                  
                elseif (flscbs(1) ~= fileSq(i, j) )
                    indD(i, j) = D(1, 4); % larger delay mbs                   
                end
                
                
           case 2
                % BECAUSE ue2 is connected to two scbs1&2
                % we accept the shorter delay one, as the delay is randomly chosen
                if (flscbs(2) == fileSq(i, j) && ...
                        flscbs(1) == fileSq(i, j))
                    d1 = D(2, 1);
                    d2 = D(2, 2);
                    [d, ind] = min([d1, d2]); % shorter delay scbs
                    indD(i, j) = d;
                elseif (flscbs(1) == fileSq(i, j))
                    indD(i, j) = D(2, 1); % scbs 1               
                elseif (flscbs(2) == fileSq(i, j) )
                    indD(i, j) = D(2, 2); % scbs 2                  
                else
                    indD(i, j) = D(2, 4); % mbs                
                end
               
                
           case 3                      
                % BECAUSE ue3 is connected to three scbs 1& 2& 3
                % we accept the shorter delay one, as the delay is randomly chosen
                if (flscbs(1) == fileSq(i, j) && ...
                        flscbs(2) == fileSq(i, j)) 
                    d1 = D(3, 1);
                    d2 = D(3, 2);
                    [d, ind] = min([d1, d2]); % shorter delay scbs
                    indD(i, j) = d;
                    
                elseif (flscbs(1) == fileSq(i, j) && ...
                        flscbs(3) == fileSq(i, j))              
                    d1 = D(3, 1);
                    d3 = D(3, 3);
                    [d, ind] = min([d1, d3]); % shorter delay scbs
                    indD(i, j) = d;
                    
                elseif (flscbs(2) == fileSq(i, j) && ...
                        flscbs(3) == fileSq(i, j))                    
                    d2 = D(3, 2);
                    d3 = D(3, 3);
                    [d, ind] = min([d2, d3]); % shorter delay scbs
                    indD(i, j) = d;
                 
                elseif (flscbs(1) == fileSq(i, j) )
                    indD(i, j) = D(3, 1); % scbs 1             
                elseif (flscbs(2) == fileSq(i, j) )
                    indD(i, j) = D(3, 2); % scbs 2               
                elseif (flscbs(3) == fileSq(i, j) )
                    indD(i, j) = D(3, 3); % scbs 3
                else
                    indD(i, j) = D(3, 4); % mbs
                end
                
                
          case 4                        
                 % BECAUSE ue4 is connected to two scbs1 & 3
                % we accept the shorter delay one, as the delay is randomly chosen
                if (flscbs(1) == fileSq(i, j) && ...
                        flscbs(3) == fileSq(i, j))
                    d1 = D(4, 1);
                    d3 = D(4, 3);
                    [d, ind] = min([d1, d3]); % shorter delay scbs
                    indD(i, j) = d;
                 
                elseif (flscbs(1) == fileSq(i, j))
                    indD(i, j) = D(4, 1); % scbs 1             
                elseif (flscbs(3) == fileSq(i, j) )
                    indD(i, j) = D(4, 3); % scbs 3              
                else
                    indD(i, j) = D(4 , 4); % mbs
                end
              
                
           case 5 
                  % ue 5 connected to scbs 2
                if (flscbs(2) == fileSq(i, j))
                    indD(i, j) = D(5, 2); % shorter delay scbs                 
                elseif (flscbs(1) ~= fileSq(i, j) )
                    indD(i, j) = D(5, 4); % larger delay mbs
                end
                
                
            case 6      
                % BECAUSE ue6 is connected to two scbs 2& 3
                % we accept the shorter delay one, as the delay is randomly chosen
                if (flscbs(2) == fileSq(i, j) && ...
                        flscbs(3) == fileSq(i, j))
                    d2 = D(6 ,2);
                    d3 = D(6 , 3);
                    [d, ind] = min([d2, d3]); % shorter delay scbs
                    indD(i, j) = d;
                 
                elseif (flscbs(2) == fileSq(i, j))
                    indD(i, j) = D(6, 2); % scbs 2               
                elseif (flscbs(3) == fileSq(i, j) )
                    indD(i, j) = D(6 , 3); % scbs 3                 
                else
                    indD(i, j) = D(6, 4); % mbs   
                end
                
                
           case 7
                % ue 7 connected to scbs 3
                if (flscbs(3) == fileSq(i, j))
                    indD(i, j) = D(7 ,3); % shorter delay scbs                  
                elseif (flscbs(3) ~= fileSq(i, j) )
                    indD(i, j) = D(7, 4); % larger delay mbs                   
                end
                
       end
        
    end
end
cF = indD .* repmat(cF,1,nUE);
end

