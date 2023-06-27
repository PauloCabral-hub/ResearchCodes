

function [string_seq, node_set] = write_tree(node, node_set, string_seq, alphabet, vtree)


% checking if the node is a vertice of the tree
ispart = 0;
    if ~isempty(node)
        for k = 1:length(vtree)
            if isequal(node, vtree{1,k})
               ispart = 1;
               break;
            end
        end
    else
        ispart = 1;
    end
    

    if ispart == 1    
        node_add_pre = ' child{ [fill] circle (2pt) node (';
    else
        node_add_pre = ' child{ [fill, white] circle (2pt) node (';
    end
node_add_pos = ') {}';
node_close = '}';

if ~isempty(node)
    node_string = replace(num2str(node), ' ', ''); new_node_string = [];
    for k = 1:length(node_string)
        new_node_string = [new_node_string node_string(k) 'o']; %#ok<AGROW>
    end
    new_node_string = new_node_string(1:end-1);

    string_seq = [string_seq node_add_pre new_node_string node_add_pos];

    for e = 1:length(node_set)
       if isequal(node, node_set{1,e})
          aux_vec = zeros( 1, length(node_set) );
          aux_vec(e) = 1;
          node_set = node_set( aux_vec == 0);
          break;
       end
    end    
end


for a = 1:length(alphabet)
    ch = [alphabet(a) node];
    aux = 1;
    while aux <= length(node_set)
        if isequal(ch, node_set{1,aux})
           node_aux = node_set{1,aux};
           [string_seq, node_set] = write_tree(node_aux, node_set, string_seq, alphabet, vtree);
           break
        end
        aux = aux+1;
    end
end

if ~isempty(node)
    string_seq = [string_seq node_close];
end

end