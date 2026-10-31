function[max_val] = max_intra_comparison_v1(val_rep)

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
    
    w_med(ii-1) = median(val_mat.w{ii}); 
    
    s_med(ii-1) = median(val_mat.s{ii}); 
 end
 
 [~,max_k] = max(k_med);
  max_k = max_k+1;
 
  [~,max_s] = max(s_med);
  max_s = max_s+1;
  
  [~,max_w] = max(w_med);
  max_w = max_w+1;
  
  max_val.wsbm = max_w;
  max_val.kmeans = max_k;
  max_val.sc = max_s;
end