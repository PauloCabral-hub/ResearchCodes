% cvec = labeling_cvec(schain, responses, context, step, in_cvec, same)
%
% The function labels response times for the cond_tauest_RT function. 
% schain = stochastic chain associated to the sequence of responses/respon-
% se times.
%
% INPUT:
% responses = responses associated to the stochastic chain.
% context = context to which the exclusion condition is related.
% step = to how many steps back the exclusion condition is related.
% in_cvec = in case of previous instances of the same function, cvec should
% be used. Otherwise [] should be used.
% same = should be (1) for exclusion based on the
% same symbol in schain and responses. Should be (0) for exclusion based on
% different symbol in schain and responses.
%
% OUTPUT:
% cvec = vector of zeros and ones to be used in cond_tauest_RT function.
% (1) indicates the response times that should be taken into account. 
% (0) indicates the response times that should not be taken into account.
%
% Author: Paulo Roberto Cabral Passos  date: 19/06/2023
%
% (checked)


function cvec = labeling_cvec(schain, responses, context, step, in_cvec, same)

    if isempty(in_cvec)
        cvec = ones(size(schain,1), size(schain,2));
    else
        cvec = in_cvec;
    end

[~, loc, ~] = count_contexts({context}, schain);

positions = find( loc(1,:) ~= 0 );
	for k = 1:length(positions) %#ok<ALIGN>
       pos = loc(1,positions(k));
       if (pos - step) > 0
          
            if same == 1
               if schain(pos-step) == responses(pos-step)
                  if ( (pos+1) <= length(responses) )
                    cvec(pos+1) = 0;
                  end
               end
            else
               if schain(pos-step) ~= responses(pos-step)
                  if ( (pos+1) <= length(responses) )
                    cvec(pos+1) = 0;
                  end
               end    
            end          
       end
    end
    
    
end

