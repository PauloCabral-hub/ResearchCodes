height = 3;
alphabet = [0 1 2];

% construct the set that will be the basis for the procedure
string_set = full_tree_with_vertices(alphabet, height);

% detecting the branches
brothers = indentifying_branches(string_set, height);

% generate all combination of branches
[tree_list, elements] = generating_subtrees(brothers, string_set);

% performing corrections
wbar = waitbar(0, 'Rectifying trees...');
for t = 1:size(tree_list,1)
    if tree_list(t,1) == 1
       % correction procedure
       if ~isempty(string_set(find(elements(t,:) == 1))) %#ok<FNDSB>
           while 1
                 modified = 0;
                 tree_aux = string_set(find(elements(t,:) == 1)); %#ok<FNDSB>
                 for w = 1:length(tree_aux)
                            uncles = generating_uncles(tree_aux{1,w}, alphabet);
                            % find where the uncles are in the string_set
                            aux_vec = pinpoint_uncleslocation(string_set, uncles);
                            % WORKING
                            elements_aux = [aux_vec + elements(t,:)]> 0;
                                if ~isequal(elements_aux, elements(t,:))
                                   % get the rectified tree
                                   tree_alt = string_set(find(elements_aux == 1)); %#ok<FNDSB>
                                   if isthisatree(tree_alt)
                                      elements(t,:) = elements_aux;
                                      modified = 1;
                                   end 
                                end
                           % WORKING
                 end
                 if modified == 0
                    break
                 end
           end
       end  
    end
    waitbar(t/length(tree_list),wbar)
end
close(wbar)

% You need to consider each uncle separately

for t = 1:length(tree_list)
    if tree_list(t,1) == 1
       draw_contexttree(string_set(elements(t,:)==1), alphabet, [0 0 0])
       pause
       close
    end
end