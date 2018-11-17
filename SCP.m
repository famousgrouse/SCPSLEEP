function [pred, idx, dist, W] =SCP(q,G,Y,K)

%q is the query points we want to search in G
%G contains all X but x contrains multiple records so we need iterate every
%set
% Y is the ground truth
% SC repeative overlape windows. for one subject we may have multipele SCs
    W=zeros(1,100);
    for sc=1:15 % we first iterate every subclass
        x=q(:,:,sc);
        [idx,dist]=knnsearch(G{sc},x,'k',K+1,'Distance','correlation');
        lambda=dist(:,K+1); %???19????6?patches ???
        for i=1:6 %????patch ????
        for c=1:100 
            % 100 people's ID we need minus the 19th nearest neighour's
            % distance for all rest data points.
            %the idx(i,:) is to find all the index from ground truth Y
            %Y's value is the people's ID, Y(idx(i,:)) is all nearest
            %neighbour's which is the peoples's ID correspondent to their
            %idx in dist set, so tha's why we have Y(idx(i,:)) == c which
            %means if the current 19 nearest neighbour contain people ID=c
            %then we will let their distance minus lambda.
            if ~isempty(dist(i,Y(idx(i,:))==c))
            W(c)=W(c)+min(dist(i,Y(idx(i,:))==c))-lambda(i);
            end
        end
        end
    end
    [~,pred]=min(W);
end
