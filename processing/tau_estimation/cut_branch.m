% tau_est = cut_branch(s,tau_est, pos, chain, rt)
%
% This function decides returns the estimated tree after deciding if a
% terminal brach should or not be prunned
%
% INPUT:
% s = the string that induces the terminal branch
% tau_est = the estimated tree
% pos = positions in the estimated tau of the strings induced by s
% chain = the stochastic chain generated by the tree we want to identify
% rt = the chain of response times
%
% OUTPUT:
% tau_est = the estimated tree after a prunning instance
%
% Author: Paulo Passos     Last Modified: 24/05/2020


function tau_est = cut_branch(s,tau_est, pos, chain, rt)


sind = cell(1,length(pos));
for a = 1:length(pos)
sind{1,a} = tau_est{1,pos(1,a)};        
end

[~, ~, count] = count_contexts(sind, chain);

nh = find(count == 0);
sit = length(pos)-length(nh);

% Case 1: all induced strings occured %

if (isempty(nh))&&(length(pos) ~= 1) % # the second condition may be unnecessary
% disp('Case 1')
ncut = prun_criteria(sind,chain, rt);
    if ncut ~= 1
        if brother_suffofacontext(tau_est, tau_est{1,pos(1,1)}, 3)
            % disp('subcase 3.1')
            % Cleaning zero counts
            if find(count == 0)
            tau_est = clean_zerocounts(tau_est, pos, count);
            end
        else
            % disp('subcase 3.2')
            tau_est = removing_branch_how(tau_est,pos,s,0);
        end
    end
end

% Caso 2: no ocurrence of any induced strings

if length(pos) == length(nh)
% disp('Case 2')
    tau_est = removing_branch_how(tau_est,pos,s,0);
end


% Case 3: Just one of the induced strings occurred

if sit == 1 
% disp('Case 3')    
posx =  pos(1,find(count ~= 0)); %#ok<FNDSB>
    if brother_suffofacontext(tau_est, tau_est{1,posx}, 3)
        % disp('subcase 3.1')
        % Cleaning zero counts
        if find(count == 0)
        tau_est = clean_zerocounts(tau_est, pos, count);
        end
    else
        % disp('subcase 3.2')
        tau_est = removing_branch_how(tau_est,pos,s,0);
    end
end

% Case 4 : At least 2 of the induced strings occurred *

if ( sit >= 2 )&&( sit < (length(pos)) )
% disp('Case 4')
    % Replacing non-occurring contexts by empty strings
    sind = cell(1,length(pos)); auxpos = [];
    for a = 1:length(pos)
        if count(a,1) == 0
        tau_est{1,pos(1,a)} = [];
        else
        auxpos = [auxpos pos(1,a)]; sind{1,a} = tau_est{1,pos(1,a)}; %#ok<AGROW>
        end
    end
    pos = auxpos;
    % Then choosing if it should be prunned
    % Option 1
    jump = 0;
    for a = 1:length(pos)
        if brother_suffofacontext(tau_est, tau_est{1,pos(a)}, 3)
           jump = 1;
        end
    end
    if jump == 0
    ncut = prun_criteria(sind,chain, rt);
        if ncut ~= 1
        tau_est = removing_branch_how(tau_est,pos,s,0); 
        end        
    end
end
    

% Cleaning
tau_est = removing_branch_how(tau_est,[],[], 1);

end


