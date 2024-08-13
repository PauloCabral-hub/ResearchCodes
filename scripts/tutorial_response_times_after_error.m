% Basic tutorial: Getting response times after an error a given number
% of steps before

% Setting the parameters

from = 1;
till = 100;
id = 1;
tree = 7;
tree_file_address = ['C:\Users\Cabral\Documents\pos_doc\ResearchCodes\files_for_reference\tree_behave' num2str(tree) '.txt'];

% Processing

[ctx_rtime, ctx_er, ctx_resp, contexts, ~, ct_pos] = rtanderperctx(data, id, from, till, tree_file_address, 0, tree);
[chain,responses, times] = get_seqandresp(data,tree, id, from, till);
[ctx_fer,ct_poscell] = lastwas_error(ct_pos, ctx_er, contexts, chain, responses,1);