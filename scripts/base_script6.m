% best_brothersfit()
bro_candidates = find(aux_vec == 1);
pos_results = permwithrep( [0 1], length(bro_candidates) );
[~, I] = sort( sum(pos_results,2),'descend' );
pos_results = pos_results(I,:);

for a = 1:size(pos_results,1)
    aux_vec = zeros( 1,size(elements,2) );
    for b = 1:size(pos_results,2)
        if pos_result(a,b) == 1
           aux_vec(1,brow_candidates(b)) = 1;
           elements_aux = [aux_vec + elements(t,:)] > 0;
           % Finish this tomorrow
        end
    end
end


% WORKING
elements_aux = [aux_vec + elements(t,:)]> 0;
    if ~isequal(elements_aux, elements(t,:))
       disp('not equal!')
       % get the rectified tree
       tree_alt = string_set(find(elements_aux == 1)); %#ok<FNDSB>
       if isthisatree(tree_alt)
          elements(t,:) = elements_aux;
          modified = 1;
       end 
    end
% WORKING