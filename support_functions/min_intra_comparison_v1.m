function[min_val] = min_intra_comparison_v1(val_rep)

K_valid = size(val_rep.wsbm, 2);

 for k = 2:K_valid
    mask_k = tril(true(size(val_rep.kmeans{k})),-1);
    k_mat{k} = reshape(val_rep.kmeans{k}(mask_k), numel(val_rep.kmeans{k}(mask_k)),1);
    mask_s = tril(true(size(val_rep.sc{k})),-1);
    s_mat{k} = reshape(val_rep.sc{k}(mask_s), numel(val_rep.sc{k}(mask_s)),1);
    mask_w = tril(true(size(val_rep.wsbm{k})),-1);
    w_mat{k} = reshape(val_rep.wsbm{k}(mask_w), numel(val_rep.wsbm{k}(mask_w)),1);
    clear mask_k mask_s mask_w;
 end
 val_mat.k = k_mat;
 val_mat.s = s_mat;
 val_mat.w = w_mat;

 for ii = 2:K_valid
    k_med(ii-1) = median(val_mat.k{ii}); 
    %k_q1(ii-1) = quantile(val_mat.k{ii}, 0.25);
    %k_q3(ii-1) = quantile(val_mat.k{ii}, 0.75);
    
    w_med(ii-1) = median(val_mat.w{ii}); 
    %w_q1(ii-1) = quantile(val_mat.w{ii}, 0.25);
    %w_q3(ii-1) = quantile(val_mat.w{ii}, 0.75);
    
    s_med(ii-1) = median(val_mat.s{ii}); 
    %s_q1(ii-1) = quantile(val_mat.s{ii}, 0.25);
    %s_q3(ii-1) = quantile(val_mat.s{ii}, 0.75);
 end
 
 [~,min_k] = min(k_med);
  min_k = min_k+1;
 
  [~,min_s] = min(s_med);
  min_s = min_s+1;
  
  [~,min_w] = min(w_med);
  min_w = min_w+1;
  
  min_val.wsbm = min_w;
  min_val.kmeans = min_k;
  min_val.sc = min_s;
end