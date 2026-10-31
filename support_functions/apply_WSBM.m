function[wsbm_results] = apply_WSBM(ave_fcmat, K_max, replication)
% apply WSBM for the average fcmatrix

% Input: 
% ave_fcmat = average fc matrix 
% K_max = maximum value of communities
% replication = number of replication, typically we set 1000

% Output: 
% wsbm_results.idx = (nROI x replication x K_max) matrix containing the
% estimated community labels
% wsbm_results.log_lik = (nROI x K_max) matrix containing the
% log-likelohood values

rng('default');
idx_mat_wsbm = [];
log_lik = [];

for ii = 1:replication
   start_time_ii = datestr(now);
   
   parfor k = 2:K_max
       % fprintf('ii=%d \t k=%d \n',ii,k);
       [Labels Model] = wsbm(ave_fcmat, k,...
           'E_Distr', 'None',...
           'W_Distr', 'Normal',...
           'numTrials', 1,...
           'verbosity', 0,...
           'alpha', 0,...
           'parallel', 0);

       idx_mat_wsbm(:,ii,k) = Labels;
       log_lik(ii,k) = Model.Para.LogEvidence;
       
   end
   
   end_time_ii = datestr(now);
   total_time_ii = diff(datenum([start_time_ii;end_time_ii]))*24*60; % min
   fprintf('Total time for %d th iteration = %f mins\n', ii,total_time_ii);
end

wsbm_results.K_max = K_max;
wsbm_results.replication = replication;
wsbm_results.idx = idx_mat_wsbm;
wsbm_results.log_lik = log_lik;

end