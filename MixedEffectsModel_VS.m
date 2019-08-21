%[ndata1, text1, alldata1] = xlsread('LongitudinalData.xlsx', 'time1no0withlmeforVS');
%[ndata2, text2, alldata2] = xlsread('LongitudinalData.xlsx', 'time2no0withlmeforVS');
[ndata1, text1, alldata1] = xlsread('ALLDATA1onlySPECT.xlsx', 'Sheet1');
[ndata2, text2, alldata2] = xlsread('ALLDATA2onlySPECT.xlsx', 'Sheet1');
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


lme = fitlme(tbl,'y ~ gender + COMT + MAPT + age + education + VS*time + (1|subject)') 
b = double(lme.Coefficients(end,7))*double(lme.Coefficients(end,8));
a = lme.Coefficients(end,6);
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

%Look index in alldata for modality 


% When inferring the results don't only look to the p values. If p value is
% significant then look to the upper and lower p values. If 0 exist between
% upper and lower values then the test result is not significant.


% lme = fitlme(tbl,'y ~ InitialWeight + Program*Week + (Week|Subject)') 
% 
% a = lme.Coefficients(:,5);
% p = double(a); 