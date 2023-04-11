function best_brothersfit(brother_list, elements)
bro_candidates = find(brother_list == 1);
pos_results = permwithrep( [0 1], length(bro_candidates) );
[~, I] = sort( sum(pos_results,2),'descend' );
pos_results = pos_results(I,:); pos_results = pos_results(1:end-1, :);

for a = 1:size(pos_results,1)
    brother_list = zeros( 1,size(elements,2) );
    for b = 1:size(pos_results,2)
        if pos_result(a,b) == 1
           brother_list(1,brow_candidates(b)) = 1;
           elements_aux = [brother_list + elements(t,:)] > 0;
           %working
            if ~isequal(elements_aux, elements(t,:))
            % get the rectified tree
            tree_alt = string_set(find(elements_aux == 1)); 
               if isthisatree(tree_alt)
                  elements(t,:) = elements_aux;
                  modified = 1; break
               end 
            end
           %working
           if modified == 1; break; end
        end
    end
    if modified == 1; break; end
end

end

