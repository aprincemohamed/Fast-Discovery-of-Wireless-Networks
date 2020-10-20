clear
n=100;
L=23;
N=3:13;
N=2.^N;
radius=75;


for K=N
    r=zeros(1,K);
    p=primes((L+1)*log2(K));
    rounds=zeros(length(p)+1,K);
    for j=2:(length(p)+1)
        for ll=1:K 
            rounds(1,ll)=ll;
            rounds(j,ll)=mod(ll,p(j-1));
        end
     end
    rn=zeros(1,n);
    for k=1:n
        shift=0;
        H=zeros(K,K);
        if (K<=L)
            H=ones(K,K);
        end
        for l=1:K
            if ((K>L)&&(K<=radius))
                c=randperm(K,L);
            end
             if ((K>L)&&(K>radius))
                 if (l<=(K-(radius-1)))
                    c=randperm(l+(radius-1),L);
                 end
                 if (l>(K-(radius-1)))
                     shift=shift+1;
                    c=randperm(l-shift+(radius-1),L);
                 end
            end           
            for i=1:L
                if (K>L)
                    H(l,c(i))=1;
                end
            end
        end
        H_channel=zeros(K,K);
        br=0;
                for m=1:length(p)
                    H_sub=zeros(K,K);
                    links=0;                    
                    a=zeros(length(unique(rounds(m+1,:))));
                    a=unique(rounds(m+1,:));
                    for m1=a
%                        H_test=H; % without IC 
                        H_test=H-H_channel; % with IC 
                        test=find(not(rounds(m+1,:)==m1)); %find indices for all transmitters that are not active
                        for tt=1:length(test)
                            H_test(:,test(tt))=0; %set all inactive links to 0
                        end
                        for ttt=1:K % iterate over whole network
                            if (sum(H_test(ttt,:))==1) %look for receivers that have only one connection after ignoring the diactivated transmitters 
                                col=find(H_test(ttt,:)==1);
                                doublecount=sum(H_channel(ttt,col)==1);
                                H_channel(ttt,col)=1; % mark found links
                                links=links+sum(H_channel(ttt,col))-doublecount;
                                H_sub(ttt,col)=1;
                            end
                        end
                        prep=H-H_channel;
                        if (br==0)
                            if (sum(prep(:))==0)
                                r1(K,k)=sum(p(1:m-1))+m1+1;
                                br=1;
                            end
                        end
                    end
                     num_links(k,m)=links;
                    if (((prep==0)))
                        h(K,k)=p(m);
                        break;
                    end
                end
    end                    
    r(1,K)=sum(r1(K,:))/n;
    num_links_avg=sum(num_links,1)/n;
end