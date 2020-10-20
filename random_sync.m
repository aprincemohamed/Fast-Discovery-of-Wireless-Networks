clear
n=100;
L=7;
N=3:13;
N=2.^N;
%N=4048:200:6096;
%N=8192;

for K=N
    r=zeros(1,K);
    rn=zeros(1,n);
    for k=1:n
        rounds=zeros(1,K);
        H=zeros(K,K);
        tic
        if (K<=L)
            H=ones(K,K);
        end
        for l=1:K
            if (K>L)
                c=randperm(K,L);
            end
            for i=1:L 
                if (K>L)
                    H(l,c(i))=1;
                end
            end
        end
        H_channel=zeros(K,K);
        br=0;
        prep=1;
        r=0;
                while (not(sum(prep(:))==0))
                    r=r+1;
                    H_sub=zeros(K,K);
                    links=0;                    
                        for l=1:K
                            rounds(1,l)=rand >=1/L;
                        end
%                        H_test=H; % without IC 
                        H_test=H-H_channel; % with IC 
                        test=find(not(rounds==1)); %find indices for all transmitters that are not active
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
                                r1(K,k)=r;
                                br=1;
                            end
                        end
                     num_links(k,r)=links;
%                     if (((prep==0)))
%                         h(K,k)=p(m);
%                         break;
%                     end
                end
    end                    
    r(1,K)=sum(r1(K,:))/n;
    num_links_avg=sum(num_links,1)/n;
end