height = 3;
alphabet = [0 1 2];
pathtogit = '/home/paulo/Documents/PauloPosDoc/Pos-Doc/ResearchCodes'; tau = 7; seq_length = 100;
tree_file_address = [pathtogit '/files_for_reference/tree_behave' num2str(tau) '.txt' ];
[contexts, PM,~ , ~] = build_treePM (tree_file_address);
seq = gentau_seq (alphabet, contexts, PM, seq_length);

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
                            [elements_row, modified] = best_uncles_fit(pinpoint_uncleslocation(string_set, uncles), elements(t,:), string_set);
                            if modified == 1
                               elements(t,:) = elements_row; break
                            end
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

elements_full = elements;

% rectifying according to the chain
wbar = waitbar(0, 'Rectifying trees according to the chain...');
for t = 1:length(tree_list)
    if tree_list(t,1) == 1
       for a = 1:size(elements,2)
           if elements(t,a) == 1
              [~, ~, occurance_count] = count_contexts(string_set(a), seq);
              if occurance_count == 0
                 elements(t,a) = 0; 
              end
           end
       end
    end
    waitbar(t/length(tree_list),wbar)
end
close(wbar)

elements = elements( find(tree_list == 1),: ); %#ok<FNDSB>
elements_full = elements_full( find(tree_list == 1),: ); %#ok<FNDSB>
[elements, ia, ic] = unique(elements, 'rows');
elements_full = elements_full(ia,:);

% % Fix only childs : solution convert the tree to vertices tree, for
% length greter than 1, if has a father but no brother, then is a only
% child.
% only_childs = 0;
% while 1
%     for t = 1:size(elements,1)
%         for a = 1:size(elements,2)
%             if elements(t,a) == 1
%                father = gen_imsufix(string_set{1,a}); bro_count = 0;
%                for b = 1:length(alphabet)
%                    bro = [alphabet(b) father];
%                    for c = 1:size(elements,2)
%                        if elements(t,c) == 1
%                           bro_count = bro_count + isequal(string_set{1,c}, bro);
%                        end
%                    end
%                end
%                if bro_count < 2
%                   % possible child found
%                   % test if it is
%                   
%                   % test if it is
%                   elements(t,a) = 0; only_childs = 1;
%                   for b = 1:size(elements,2)
%                       if isequal(father, string_set{1,b})
%                          elements(t,b) = 1;
%                       end
%                   end
%                end
%             end
%         end

%     end
%     if only_childs == 0; break; end
% end

% %Reasoning
% for t = 1:length(tree_list)
%     if tree_list(t,1) == 1
%        draw_contexttree(string_set(elements_full(t,:)==1), alphabet, [0 0 0])
%        pause
%        close
%     end
% end
