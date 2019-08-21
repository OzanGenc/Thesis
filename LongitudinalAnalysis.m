[ndata1, text1, alldata1] = xlsread('ASL.xlsx', 'ALL_CBF'); %change  
[ndata2, text2, alldata2] = xlsread('ASL.xlsx', 'ALL_BAT'); %change 

alpha = 0.05;

% Levene's test
for k=1:size(ndata1,2)
    
   lev = [ndata1(:,k);ndata2(:,k)];
   levg = [zeros(size(ndata1,1),1);ones(size(ndata2,1),1)]; 
   
   plev(k) = vartestn(lev,levg,'TestType','LeveneAbsolute','Display','off');
   
    
end

plev_result = (plev<=0.05);
unequal_var_num = sum(plevresult);


% Wilcoxon Rank Sum Test

for i=1:size(ndata1,2)
    
p(i) = signrank(ndata1(:,i),ndata2(:,i));
p_corr(i) = alpha./(size(ndata1,2)-i+1);
ind(i)=i;

end

ind_p = [ind;p];

[temp, order] = sort(ind_p(2,:));
sorted_p = ind_p(:,order);
result = [sorted_p; p_corr];

significants = find(result(2,:)<=result(3,:));