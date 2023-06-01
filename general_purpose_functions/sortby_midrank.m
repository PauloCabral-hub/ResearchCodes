% x_mr = sortby_midrank(x)
%
% The function receive a column vector (x) and return a vector containing a
% ranking of values with midranks (x_mr).
%
% author: Paulo Roberto Cabral Passos date: 31/05/2023

function x_mr = sortby_midrank(x)
    [~, idxes] = sort(x);

    x_mr = zeros(1,length(x));
    k1 = 1;
    while k1 <=length(idxes)
        aux = find(x == x(idxes(k1)) );
        for k2 = 1:length(aux)
            x_mr(aux) = k1;        
        end
        k1 = k1+length(aux);
    end

    k = 1;
    while k < length(x_mr)
       dble = 0;
       aux = find(x_mr == k);
       if length(aux)>1
          dble = 1;
          mrank = sum([k: k+length(aux)-1])/length(aux);
          x_mr(aux) = mrank;
       end
       if dble == 0
          k = k+1;
       else
          k = floor(mrank + 1); 
       end
    end

end