[ndata1, text1, alldata1] = xlsread('time11.xlsx', 'time11nospect');
[ndata2, text2, alldata2] = xlsread('time22.xlsx', 'time22nospect');
%[ndata1, text1, alldata1] = xlsread('ALLDATA1onlynpt.xlsx', 'Sheet1');
%[ndata2, text2, alldata2] = xlsread('ALLDATA2onlynpt.xlsx', 'Sheet1');


ndata1(2,:) = [];
ndata2(2,:) = [];
alldata1(3,:) = [];
alldata2(3,:) = [];


longform=zeros(size(ndata1,1)*2,size(ndata1,2));
k=1;
alpha = 0.05;
for i=1:2:(size(ndata1,1)*2-1)
    longform(i,:) = ndata1(k,:);
    longform(i+1,:) = ndata2(k,:);
    k=k+1;
end

tags=text1(1,:);

time_ind=find(strcmp(tags,'time')==1);
time=longform(:,time_ind);


subject_ind = find(strcmp(tags,'ID')==1);
subject = longform(:,subject_ind);


age_ind = find(strcmp(tags,'age')==1);
age=longform(:,age_ind);


MAPT_ind = find(strcmp(tags,'MAPT')==1);
MAPT = longform(:,MAPT_ind);


COMT_ind = find(strcmp(tags,'COMT')==1);
COMT = longform(:,COMT_ind);


VS_ind = find(strcmp(tags,'VS')==1);
VS = longform(:,VS_ind);


gender_ind = find(strcmp(tags,'gender')==1);
gender = longform(:,gender_ind);


education_ind = find(strcmp(tags,'education')==1);
education = longform(:,education_ind);


for f=1:(size(longform,2)-8)

y = longform(:,f);
    
tbl = table(VS,age,subject,time,COMT,MAPT,gender,education,y);
tbl.subject = nominal(tbl.subject);
tbl.time = nominal(tbl.time);
tbl.VS = nominal(tbl.VS);
tbl.COMT = nominal(tbl.COMT);
tbl.MAPT = nominal(tbl.MAPT);
tbl.gender = nominal(tbl.gender);


% lme = fitlme(tbl,'y ~ gender + COMT + MAPT + age + education + VS + time + (1|subject)') 
% b = double(lme.Coefficients(4,7))*double(lme.Coefficients(4,8));
% a = lme.Coefficients(4,6);
% p(f) = double(a); 
% sgn(f) = sign(b); 




lme = fitlme(tbl,'y ~ gender + COMT + MAPT + age + education + time + (1|subject)') 
b = double(lme.Coefficients(3,7))*double(lme.Coefficients(3,8));
a = lme.Coefficients(3,6);
p(f) = double(a); 
sgn(f) = sign(b); 








p_corr(f) = alpha./(size(ndata1,2)-8-f+1);
ind(f)=f;

end


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
newlongdata = [longform(:,result(1,1:size(signedsignificants,2))) longform(:,end-7:end)];

%Look index in alldata for modality 


% When inferring the results don't only look to the p values. If p value is
% significant then look to the upper and lower p values. If 0 exist between
% upper and lower values then the test result is not significant.


% lme = fitlme(tbl,'y ~ InitialWeight + Program*Week + (Week|Subject)') 
% 
% a = lme.Coefficients(:,5);
% p = double(a); 



