% [tau_est] = tauest_RT(alphal, rt, chain, show)
%
% This function returns the estimated tree from the chain of response
% times and the stochastic chain .
% INPUT: 
% alphal = length of the alphabet of the stochastic chain
% rt = chain of response times
% chain = stochastic chain associated with rt
% show = plots the estimated tree
%
% OUTPUT:
% tau_est = cell with the contexts of the estimated tree
%
% Author: Paulo Roberto Cabral Passos Last Modified: 02/08/2020


function [tau_est] = tauest_RT(alphal, rt, chain, show)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    A = zeros(1,alphal);
    for a = 1:alphal
        A(1,a) = a-1;
    end
    L = floor(log10(length(chain))/log10(3));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    perm = permwithrep(A,L);

    tau_est = cell(1,length(A)^L);

    for a = 1:size(perm,1)
    tau_est{1,a} = perm(a,:);
    end

    for h = 1:L
        if (L-h) == 0 % Visiting the root branch.
            perm = [];
            branchs = 1;
        else
            perm = permwithrep(A,L-h);
            branchs = size(perm,1);
        end
        % Finding the leafs of the branch
        for a = 1:branchs
           pos = []; 
           for b = 1:length(tau_est)
                if (branchs == 1)&&(L-h == 0) % visiting the root branch
                    if length(tau_est{1,b}) == 1 
                            pos = [pos b]; %#ok<AGROW> No need to test if they are equal
                    end                    
                else
                    if(length(tau_est{1,b}) == (length(perm(a,:))+1))
                        aux = sum(perm(a,:) == tau_est{1,b}(2:end),2)/length(perm(a,:)); % Testing if they are equal
                        if  aux == 1
                            pos = [pos b]; %#ok<AGROW>
                        end
                    end    
                end
           end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
        % Pruning Procedure
            if ~isempty(pos)
                if isempty(perm) % Root branch
                    tau_est = cut_branch(perm,tau_est, pos, chain, rt);
                else % Other branches
                    tau_est = cut_branch(perm(a,:),tau_est, pos, chain, rt);
                end
            end
        end
    end

    if show == 1
    draw_contexttree(tau_est, A)
    end
end
