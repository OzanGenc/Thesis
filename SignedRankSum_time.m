%[ndata1, text1, alldata1] = xlsread('ALLDATA12.xlsx', 'ALLDATA1no0nospect');
%[ndata2, text2, alldata2] = xlsread('ALLDATA12.xlsx', 'ALLDATA2no0nospect');
[ndata1, text1, alldata1] = xlsread('ALLDATA1onlynpt.xlsx', 'Sheet1');
[ndata2, text2, alldata2] = xlsread('ALLDATA2onlynpt.xlsx', 'Sheet1');

ndata1(2,:) = [];
ndata2(2,:) = [];
alldata1(2,:) = [];
alldata2(2,:) = [];


alpha = 0.05;


for f=1:(size(ndata1,2)-8)
  
p(f) = signrank(ndata1(:,f),ndata2(:,f)); 
 
p_corr(f) = alpha./(size(ndata1,2)-8-f+1);
ind(f)=f;

end
sgn=ones(size(p));

ind_p = [ind;p;sgn];

[temp, order] = sort(ind_p(2,:));
sorted_p = ind_p(:,order);
result = [sorted_p; p_corr];

significants = result(1,find(result(2,:)<=result(4,:)));
signedsignificants = result(3,find(result(2,:)<=result(4,:))).*significants;


info1 = alldata1(:,end-7:end);
info2= alldata2(:,end-7:end);


survivedregions = alldata1(1,result(1,1:size(signedsignificants,2)));
survivedregions = transpose(survivedregions);
newdata1 = [alldata1(:,result(1,1:size(signedsignificants,2))) info1];
newdata2 = [alldata2(:,result(1,1:size(signedsignificants,2))) info2];

%Look index in alldata for modality 
