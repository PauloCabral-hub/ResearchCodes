% getting the limit tree
limit_tree = cell(1,sum(vec_let));
aux_add = 1;
for w = 1:length(vec_let)
    if vec_let(1,w) == 1
       limit_tree{1,aux_add} = all_retrieved{1,w};
       aux_add = aux_add + 1;
    end
end

limit_tree_alt = cell( size(limit_tree,1),size(limit_tree,2) );
% transforming the limit tree
for a = 1:length(limit_tree)
    w = limit_tree{1,a};
    aux_w = [];
    for b = 1:length(w)
       aux_w = [aux_w ( w(b)+1 )];  
    end
    limit_tree_alt{1,a} = aux_w;
end

% transforming the vertices
vertices = cell( size(all_retrieved,1),size(all_retrieved,2) );
for a = 1:length(all_retrieved)
    w = all_retrieved{1,a};
    aux_w = [];
    for b = 1:length(w)
       aux_w = [aux_w ( w(b)+1 )];  
    end
    vertices{1,a} = aux_w;
end

% defining the classes
classes = ones( size(all_retrieved,1),size(all_retrieved,2) )+1;
eptree = epoch_trees{ep,1};
for a = 1:length(eptree) 
   for b = 1:length(all_retrieved)
       if isequal(eptree(a), all_retrieved(b))
          classes(1,b) = 1; 
       end
   end
end

alphabet = [1 2 3];
tree = limit_tree_alt;
label_contexts = 0;
vcounts = all_retcounts;
null_class = 2;
string_seq = tikz_tree(tree, alphabet, 0, vertices, vcounts, null_counts, classes, null_class);

% sibling_distances = [28, 10, 8, 6, 3];
