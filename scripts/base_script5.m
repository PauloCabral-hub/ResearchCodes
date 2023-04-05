
height = 3;
alphabet = [0 1 2];

% construct the set that will be the basis for the procedure
string_set = {};aux = 1;
for h = 1:height
    new_strings = permwithrep(alphabet, h);
    for k = 1:size(new_strings,1)
        string_set{1,aux} = new_strings(k,:); %#ok<SAGROW>
        aux = aux+1;
    end
end

% detecting the branches
l = length(string_set);
level = height-1;
brothers = zeros(1,l);
aux = 1;
while level ~= 0
      for a = 1:l
          for b = 1:l
             if b ~= a
                if length(string_set{1,b}) == ( length(string_set{1,a})+1 )
                   if sufix_test(string_set{1,a}, string_set{1,b})
                      brothers(1,b) = a; 
                   end
                end
             end
          end
      end
      level = level-1;
end

brothers = brothers + 1;

% generate all combination of branches
branch_comb = permwithrep([0 1], 13);
tree_list = zeros( size(branch_comb,1), 1 );
elements = zeros( size(branch_comb,1), length(string_set) );
wbar = waitbar(0, 'Computing the number of trees...');
for bc = 1:size(branch_combinations,1)
    aux_list = branch_comb(bc,:);
    tree_aux = cell(1,sum(aux_list)*3); aux_add = 1;
    for a = 1:length(aux_list)
        if aux_list(1,a) == 1
           for w = 1:size(brothers,2)
               if brothers(1,w) == a
                  elements(bc,w) = 1;
                  tree_aux{1,aux_add} = string_set{1,w};
                  aux_add = aux_add + 1;
               end
           end
        end
    end
    % suffix test
    istree = 1;
    for a = 1:length(tree_aux)
        for b = 1:length(tree_aux)
            if (a ~= b)
               if sufix_test(tree_aux{1,a},tree_aux{1,b})
                  istree = 0;
                  break;
               end
            end
        end
        if istree == 0
           break; 
        end
    end
    tree_list(bc,1) = istree;
    waitbar( bc*1/size(branch_combinations,1), wbar)
end
close(wbar)

% independent tree test
for a = 1:size(tree_list,1)
    if sum(  branch_comb( a, 1:length(alphabet) )  ) > 1
       if sum(  branch_comb( a, length(alphabet)+1:end )  ) > 1
          tree_list(a,1) = 0; 
       end
    end
end

% performing corrections
for t = 1:size(tree_list,1)
    if tree_list(t,1) == 1
       tree_aux = cell( 1, sum(elements,t) ); aux_add = 1;
       for a = 1:size(elements,2)
           if elements(t,a) == 1
              tree_aux(1,aux_add) = string_set{1,a};
           end
       end
       % correction procedure : the tree is already in string_set
        % stack overflow
        for w = 1:length(tree_aux)
            if ~isempty(tree_aux)
                for w_alt = 1:length(tree_aux)
                    if w ~= w_alt
                        % identifying the brothers
                        if length(tree_aux{1,w})>1
                           w_aux = tree_aux{1,w}(1,2:end);
                           if length(w_aux) ~= 1
                              w_bros = zeros( length(alphabet)-1,length(w_aux) ); aux_add2 = 1;
                              for a = 1:length(alphabet)
                                  if w_aux(1,1) ~= alphabet(a)
                                     w_bros(aux_add2,:) = [ alphabet(a) w_aux(1,2:end)]; 
                                     aux_add2 = aux_add2 + 1;
                                  end
                              end
                           else 
                              w_bros = zeros( length(alphabet)-1,1); aux_add2 = 1;
                              for a = 1:length(alphabet)
                                  if w_aux(1,1) ~= alphabet(a)
                                     w_bros(aux_add2,:) = alphabet(a); 
                                     aux_add2 = aux_add2 + 1;
                                  end
                              end       
                           end
                        end
                        % brothers should be addedd?
                    end
                end 
            end
        end
        % stack overflow       
    end
end


% % reasoning
% for a = 1:size(tree_list)
%    if tree_list(a,1)
%       % re-used
%       aux_list = branch_comb(a,:);
%       tree_aux = cell(1,sum(aux_list)*3); aux_add = 1;
%       for b = 1:length(aux_list)
%           if aux_list(1,b) == 1
%              for w = 1:size(brothers,2)
%                  if brothers(1,w) == b
%                     tree_aux{1,aux_add} = string_set{1,w};
%                     aux_add = aux_add + 1;
%                  end
%              end
%           end
%       end
%       % re-used
%       draw_contexttree(tree_aux, [0 1 2], [0 0 0])
%       pause
%       close all
%    end
% end
% 
