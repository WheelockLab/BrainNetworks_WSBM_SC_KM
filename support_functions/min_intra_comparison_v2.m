function[min_val] = min_intra_comparison_v2(val_rep)

K_valid = size(val_rep.wsbm, 2);
 
  for ii = 2:K_valid
    k_med(ii-1) = median(val_rep.kmeans{ii}); 
    
    w_med(ii-1) = median(val_rep.wsbm{ii}); 
    
    s_med(ii-1) = median(val_rep.sc{ii}); 
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