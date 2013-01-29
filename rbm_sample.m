%% load rbm
makebatches;
[numcases numdims numbatches]=size(batchdata);
load mnistvh.mat

batch = 1;

visbias = repmat(visbiases,numcases,1);
hidbias = repmat(hidbiases,numcases,1); 

%% sample

data = batchdata(:,:,batch);
data = data > rand(numcases,numdims);  

poshidprobs = 1./(1 + exp(-data*vishid - hidbias));    
poshidact   = sum(poshidprobs);

poshidprobs(1,:)
