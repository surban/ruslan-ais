s = size(batchdata);

fbatchdata = zeros(s(1) * s(3), s(2));
for i=1:s(3)
    fbatchdata((i-1)*s(1)+1 : i*s(1),:) = batchdata(:,:,i);
end

save('mnist.mat', 'fbatchdata');
