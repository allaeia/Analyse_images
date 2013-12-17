%function im=divm(gim)
%divergence CHambolle scheme for B and W images
function im=divm2(gim)

    function cs=c(s)
        cs=1./sqrt(1+s);
    end
    function cs=cprim(s)
        cs=-1./(2*(sqrt(1+s)).^3);
    end

    [ny,nx,m]=size(gim);

    ux = zeros(ny,nx);
    ux(:,1:end-1) = gim(:,2:end,1) - gim(:,1:end-1,1);

    uy = zeros(ny,nx);
    uy(1:end-1,:) = gim(2:end,:,2) - gim(1:end-1,:,2);

    norm_grad2 = ux.*ux + uy.*uy;
    cgrad = c(norm_grad2);
    cprim_grad = cprim(norm_grad2);

    uxx=zeros(ny,nx);
    uxx(:,1)=gim(:,1,1);
    uxx(:,end)=-gim(:,end-1,1);
    uxx(:,2:end-1)=gim(:,2:end-1,1)-gim(:,1:end-2,1);

    uyy=zeros(ny,nx);
    uyy(1,:)=gim(1,:,2);
    uyy(end,:)=-gim(end-1,:,2);
    uyy(2:end-1,:)=gim(2:end-1,:,2)-gim(1:end-2,:,2);

    uxy=zeros(ny,nx);
    uxy(:,1)=gim(:,1,2);
    uxy(:,end)=-gim(:,end-1,2);
    uxy(:,2:end-1)=gim(:,2:end-1,2)-gim(:,1:end-2,2);

    uee=((ux.*ux).*uxx + (uy.*uy).*uyy + 2.*ux.*uy.*uxy);%./norm_grad2;
    unn=((ux.*ux).*uyy + (uy.*uy).*uxx - 2.*ux.*uy.*uxy);%./norm_grad2;
    for row = 1 : size(uee,1)
        for col = 1 : size(uee,2)
            aa = norm_grad2(row,col);
            if(aa~=0)
                uee(row,col) = uee(row,col)/aa;
                unn(row,col) = unn(row,col)/aa;
            end
        end
    end


    im=cgrad.*uee+(cgrad+2*norm_grad2.*cprim_grad).*unn;
end