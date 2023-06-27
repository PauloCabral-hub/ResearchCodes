
function vtree = vertice_tree(alphabet, tree)
    
height = 0;
    for k = 1:length(tree)
        if length(tree{1,k}) > height
           height = length(tree{1,k}); 
        end
    end
[string_set, velements] = build_verticetree(alphabet, tree, height);
vtree = string_set(find(velements == 1)); %#ok<FNDSB>

end