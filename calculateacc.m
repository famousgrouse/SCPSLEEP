%get the size of the array
W_countidx = zeros(1,3); %the predicted sleep disorder type by counting their index
W_distance = zeros(1,3); %the predicted sleep disorder type by sum up their knn distance
W_distance_lambda = zeros(1,3); % the predicted sleep disorder type by their distance minus the lambda
[dim1, dim2] = size(dist);
lambda = dist(:,100);
for seg_idx =1:dim1    
    for disorder_num = 1:3
        if ~isempty(dist(seg_idx,Ytrain(idx(seg_idx,:)) == disorder_num))
            W_countidx(disorder_num) = W_countidx(disorder_num) + sum(Ytrain(idx(seg_idx,:))==disorder_num);
            W_distance(disorder_num) =  W_distance(disorder_num) + sum(dist(seg_idx,Ytrain(idx(seg_idx,:)) == disorder_num));
            W_distance_lambda(disorder_num) =  W_distance_lambda(disorder_num) + min(dist(seg_idx,Ytrain(idx(seg_idx,:)) == disorder_num))- lambda(seg_idx);
        end
    end
end

[values,maxidx] = max(W_countidx);
[values,maxidx] = max(W_distance);
[values,maxidx] = max(W_distance_lambda);