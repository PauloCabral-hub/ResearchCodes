% comparing response times across contexts

pathtogit = '/home/paulocabral/Documents/pos-doc/pd_paulo_passos_neuromat/ResearchCodes';
addpath(genpath(pathtogit))

% loading data

load('/home/paulocabral/Documents/pos-doc/pd_paulo_passos_neuromat/data_repository_15042023/data_files_r02/valid_20092022.mat')
load('/home/paulocabral/Documents/pos-doc/pd_paulo_passos_neuromat/data_repository_15042023/thesis_data_r01/set2_matrix.mat')

% getting mean response times of the contexts
tau = 7;
tree_file_address = [pathtogit '/files_for_reference/tree_behave' num2str(tau) '.txt' ];
[contexts, PM,~ , ~] = build_treePM (tree_file_address);

meanrt_ctx = zeros(sum(valid_p),length(contexts));
meanrt_order = zeros(sum(valid_p),length(contexts));
aux = 1;
for p = 1:length(valid_p)
    if valid_p(p) == 1
       [ctx_rtime,~, ~, ~, ~, ct_pos] = rtanderperctx(data, p, 100, 900, tree_file_address, 0, tau);
       for c = 1:length(contexts)
           meanrt_ctx(aux,c) = trimmean(ctx_rtime{c,1},5);
       end
       [~,idxes] = sort(meanrt_ctx(aux,:),'ascend');
       meanrt_order(aux,:) = idxes;
    aux = aux+1;
    end
end

box = [];
box_groups = [];
for b = 1:length(contexts)
    box = [box; meanrt_order(:,b)];
    box_groups = [box_groups; b*ones(size(meanrt_order,1),1)];
end

sbox_varsize(box, box_groups,  '', '', '', {'0';'01';'11';'21';'2'}, 0, 0, [])
axis square
