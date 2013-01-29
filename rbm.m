% Version 1.000 
%
% Code provided by Ruslan Salakhutdinov 
%
% Permission is granted for anyone to copy, use, modify, or distribute this
% program and accompanying programs and documents for any purpose, provided
% this copyright notice is retained and prominently displayed, along with
% a note saying that the original programs are available from our
% web page.
% The programs and documents are distributed without any warranty, express or
% implied.  As the programs were written for research purposes only, they have
% not been tested to the degree that would be advisable in any important
% application.  All use of these programs is entirely at the user's own risk.

% This program trains Restricted Boltzmann Machine in which
% visible, binary, stochastic pixels are connected to
% hidden, binary, stochastic feature detectors using symmetrically
% weighted connections. Learning is done with 1-step Contrastive Divergence.   
% The program assumes that the following variables are set externally:
% maxepoch  -- maximum number of epochs
% numhid    -- number of hidden units 
% batchdata -- the data that is divided into batches (numcases numdims numbatches)
% restart   -- set to 1 if learning starts from beginning 
% CD        -- number of CD steps.

% This is a slightly modified version of the program that was originally written 
% by Geoffrey Hinton and Ruslan Salakhutdinov.

randn('state',30);
rand('state',30);
lcgrand_seed(30);

anneal_lr = 0; 
restart = 1;

epsilonw_0      = 0.05;   % Learning rate for weights 
epsilonvb_0     = 0.05;   % Learning rate for biases of visible units 
epsilonhb_0     = 0.05;   % Learning rate for biases of hidden units 

weightcost  = 0.0002;   
initialmomentum  = 0.5;
finalmomentum    = 0.9;

%maxepoch = 1;

[numcases numdims numbatches]=size(batchdata);

if restart ==1,
  restart=0;
  epoch=1;

% Initializing symmetric weights and biases. 
  %vishid     = 0.01*randn(numdims, numhid);
  vishid     = 0.01*(0.5 - mrand(numdims, numhid));
  hidbiases  = zeros(1,numhid);
  visbiases  = zeros(1,numdims);

  poshidprobs = zeros(numcases,numhid);
  neghidprobs = zeros(numcases,numhid);
  posprods    = zeros(numdims,numhid);
  negprods    = zeros(numdims,numhid);
  vishidinc  = zeros(numdims,numhid);
  hidbiasinc = zeros(1,numhid);
  visbiasinc = zeros(1,numdims);
  batchposhidprobs=zeros(numcases,numhid,numbatches);
end

fprintf('weights:\n');
vishid(1:5,1:5)

for epoch = epoch:maxepoch
 fprintf(1,'epoch %d\r',epoch); 

 if anneal_lr == 1 
   CD = ceil(epoch/10);  
   epsilonw = epsilonw_0/(1*CD);
   epsilonvb = epsilonvb_0/(1*CD);
   epsilonhb = epsilonhb_0/(1*CD);
 else
   epsilonw = epsilonw_0;
   epsilonvb = epsilonvb_0;
   epsilonhb = epsilonhb_0;
 end 

 errsum=0;
 for batch = 1:numbatches,
 %for batch = 1:599
   fprintf(1,'epoch %d batch %d\r',epoch,batch); 

   visbias = repmat(visbiases,numcases,1);
   hidbias = repmat(hidbiases,numcases,1); 
   %%%%%%%%% START POSITIVE PHASE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   data = batchdata(:,:,batch);
   data = data > mrand(numcases,numdims);  

   poshidprobs = 1./(1 + exp(-data*vishid - hidbias));    
   posprods    = data' * poshidprobs; % matches first part of dweights
   poshidact   = sum(poshidprobs); % matches first part of dbias_hid
   posvisact = sum(data); % matches first part of dbias_vis

   %%%%%%%%% END OF POSITIVE PHASE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   poshidprobs_temp = poshidprobs;

   %%%%% START NEGATIVE PHASE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   for cditer=1:CD
     poshidstates = poshidprobs_temp > mrand(numcases,numhid);
     negdata = 1./(1 + exp(-poshidstates*vishid' - visbias));
     negdata = negdata > mrand(numcases,numdims); 
     poshidprobs_temp = 1./(1 + exp(-negdata*vishid - hidbias));
   end 
   neghidprobs = poshidprobs_temp;     

   negprods  = negdata'*neghidprobs; % matches second part of dweights
   neghidact = sum(neghidprobs); % matches second part of dbias_hid
   negvisact = sum(negdata); % matches second part of dbias_vis   

   %%%%%%%%% END OF NEGATIVE PHASE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   err= sum(sum( (data-negdata).^2 ));
   errsum = err + errsum;

   if epoch>5,
     momentum=finalmomentum;
   else
     momentum=initialmomentum;
   end;

   if false
       fprintf('weights_step:\n');
       weights_step = (posprods-negprods)/numcases;
       weights_step(1:5,1:5) 
       fprintf('visbias_step:\n');
       visbias_step = (posvisact-negvisact)/numcases;
       visbias_step(1:5)
       fprintf('hidbias_step:\n');
       hidbias_step = (poshidact-neghidact)/numcases;
       hidbias_step(1:5)  
   end
   %return
   
   %%%%%%%%% UPDATE WEIGHTS AND BIASES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    vishidinc = momentum*vishidinc + ...
                epsilonw*( (posprods-negprods)/numcases - weightcost*vishid); % matches weights_update
    visbiasinc = momentum*visbiasinc + (epsilonvb/numcases)*(posvisact-negvisact); % matches bias_vis_update
    hidbiasinc = momentum*hidbiasinc + (epsilonhb/numcases)*(poshidact-neghidact); % matches bias_hid_update

    vishid = vishid + vishidinc;
    visbiases = visbiases + visbiasinc;
    hidbiases = hidbiases + hidbiasinc;
    %%%%%%%%%%%%%%%% END OF UPDATES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
        
  end    
  fprintf(1, 'epoch %4i error %6.1f  \n', epoch, errsum); 
  
  filename = sprintf('matlab_epoch%d.mat', epoch);
  save(filename, 'vishid', 'visbiases', 'hidbiases');
  
end

fprintf('after weights:\n');
vishid(1:5,1:5)
fprintf('after visbias:\n');
visbiases(1:5)
fprintf('after hidbias:\n');
hidbiases(1:5)

fprintf('random state: %20d\n', lcgrand_uint32());


