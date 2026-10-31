function[max_val] = max_intra_comparison_v2(val_rep)

K_valid = size(val_rep.wsbm, 2);
 
  for ii = 2:K_valid
    k_med(ii-1) = median(val_rep.kmeans{ii}); 
    
    w_med(ii-1) = median(val_rep.wsbm{ii}); 
    
    s_med(ii-1) = median(val_rep.sc{ii}); 
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