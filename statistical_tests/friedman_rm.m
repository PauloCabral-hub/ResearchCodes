% [ts, ss_total, chi_df, p] = friedman_rm(box_mat)
%
% This function reproduces the friedman repeated measures test described in
% Enc. of Research Design (Salkind, 2010) and Nemenyi post-hoc test descri
% bed (Pereira, Afonso e Medeiros, 2015, journal: Communication in Statis
% tics-Simulation and Computation) in in case of statistical difference
%
% author: Paulo Roberto Cabral Passos date: 31/05/2023


function [ts, ss_total, chi_df, p, rhs_q_coefficient, sum_diffs] = friedman_rm(box_mat)

% Data in Enc. of Research Design (Salkind, 2010)
%     box1 = [72 65 69 65 71 65 82 83 77 78]';
%     box2 = [65 67 65 61 62 60 72 71 73 74]';
%     box3 = [66 67 68 60 63 61 73 70 72 73]';
%     box_mat = [box1 box2 box3];

    ord_mat = zeros(size(box_mat,1), size(box_mat,2));
    for r = 1:size(box_mat,1)
        ord_mat(r,:) = sortby_midrank(box_mat(r,:));
    end

    vec_mat = reshape(ord_mat, size(ord_mat,1)*size(ord_mat,2),1);
    all_rank_mean = mean(vec_mat);

    ts_num = 0;

    for k = 1:size(ord_mat,2)
       ts_num = ts_num + (mean(ord_mat(:,k))-all_rank_mean)^2;
    end
    ts_num = ts_num*size(ord_mat,1);

    ts_denom = 0;
    for k = 1:length(vec_mat)
       ts_denom = ts_denom + (vec_mat(k)-all_rank_mean)^2; 
    end
    ts_denom = ts_denom/(size(ord_mat,1)*(size(ord_mat,2)-1));

    ts = ts_num/ts_denom;
    
    ss_total = ts_denom*(size(ord_mat,1)*(size(ord_mat,2)-1));
    chi_df = size(box_mat,2)-1;
    p = chi2cdf(ts,size(ord_mat,2)-1);
    
    % Nemenyi post-hoc test
    sum_diffs = zeros(size(box_mat,2), size(box_mat,2));
    for r = 1:size(box_mat,2)
       for c = 1:size(box_mat,2)
           sum_diffs(r,c) = abs( sum(box_mat(:,r))-sum(box_mat(:,c)) );
       end
    end
    rhs_q_coefficient = sqrt(size(box_mat,1)*size(box_mat,1)*(size(box_mat,1)+1)/12); 

end