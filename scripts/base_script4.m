% Distance histogram

alphabet = [0 1 2]; height = 5;
pathtogit = '/home/paulocabral/Documents/pos-doc/pd_paulo_passos_neuromat/ResearchCodes'; tau = 7;
tree_file_address = [pathtogit '/files_for_reference/tree_behave' num2str(tau) '.txt' ];
[contexts, PM,~ , ~] = build_treePM (tree_file_address);
tree_a = contexts;

load('/home/paulocabral/Documents/pos-doc/pd_paulo_passos_neuromat/data_repository_15042023/simulation_data/tau7_trees_of_size5_or_less.mat');
simplified_set = string_set;
D = zeros( size(elements,1), 1 );
for t = 1:size(elements,1)
    tree_b = simplified_set(find(elements(t,:) == 1)); %#ok<FNDSB>
    D(t,1) = balding_distance(tree_a, tree_b, alphabet, height);
end
close all
set(0, 'DefaultFigureRenderer', 'painters')
set(0, 'DefaultFigureColor', [1 1 1] )
subplot(1,3,1)
h = histogram(D, 'BinWidth', 0.05, 'FaceColor', [0 0 0], 'LineWidth', 1.25);
h.Orientation = 'horizontal';
title('Possible distances')
xlabel('number of trees')
ylabel('d(\tau, \tau_{k})')
xlim([0 20])
set(gca, 'FontName', 'Times', 'fontsize',14)

% Calculating the distances from the data
load('/home/paulocabral/Documents/pos-doc/pd_paulo_passos_neuromat/data_repository_15042023/thesis_data_r01/set2_estimated_trees_of_valid.mat');

subplot(1,3,[2 3])
hold on
D_data = zeros( size(est_trees,1), size(est_trees,2) );
for ep = 1:size(est_trees,2)
    for t = 1:size(est_trees,1)
        tree_b = est_trees{t,ep};
        D_data(t,ep) = balding_distance(tree_a, tree_b, alphabet, height);    
    end
end

delta_D  = zeros( size(est_trees,1), 3 );
for d = 1:3
    if d <= 2
        for t = 1:size(est_trees,1)
            delta_D(t,d) = D_data(t,d+1)-D_data(t,d);
        end
    else
        for t = 1:size(est_trees,1)
            delta_D(t,d) = D_data(t,3)-D_data(t,1);
        end 
    end
end

group_id = []; data = [];
for g = 1:2
    %aux_comp = ~isoutlier(delta_D(:,g));
    aux_comp = logical(ones(length(delta_D),1)); %#ok<LOGL>
    group_id = [group_id; g*ones(sum(aux_comp),1)];
    data = [data; delta_D(aux_comp,g)];
end

group_idD = []; dataD = [];
for g = 1:3
    aux_comp = logical(ones(length(D_data),1)); %#ok<LOGL>
    group_idD = [group_idD; g*ones(sum(aux_comp),1)]; %#ok<AGROW>
    dataD = [dataD; D_data(aux_comp,g)]; %#ok<AGROW>
end

% Excluding the empty trees.
% data_inl = [];
% group_id_inl = [];
% for d = 1:length(data)
%     if data(d) < 0.6
%         data_inl = [data_inl; data(d)];  %#ok<AGROW>
%         group_id_inl = [group_id_inl; group_id(d)]; %#ok<AGROW>
%     end
% end


sbox_varsize(group_id, data,  '', '$\Delta d$', '', {'ep_{2}-ep_{1}';'ep_{3}-ep_{2}'}, 0.025, 1, [])
axis square

sbox_varsize(group_idD, dataD,  'epochs', '$d(\tau,\hat{ \tau })$', '', {'1';'2';'3'}, 0.025, 0, [])
axis square


[p,h,stats] = signrank(delta_D(:,1),...
		delta_D(:,2), 'tail','left') 