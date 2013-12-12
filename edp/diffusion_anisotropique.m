function diffusion_anisotropique()
    function cs=c(s)
        %cs=1;
        cs=1./sqrt(1+s);
    end
    function cs=cprim(s)
        %cs=0;
        cs=-1./(2*(sqrt(1+s)).^3);
    end
    close all;
    img=imread('LENA.BMP');
    N=size(img,1);
    img=double(img(:,:,1));
    sigma_b = 7;
    b=sigma_b * randn(size(img));
    u0 = img + b;
    u=u0;
    K=100;
    dt=.1;
    
    for k = 1:K
    
        ux = zeros(N,N);
        ux(:,1:N-1) = u(:,2:N) - u(:,1:N-1);
    
        uy = zeros(N,N);
        uy(1:N-1,:) = u(2:N,:) - u(1:N-1,:);

        norm_grad2 = ux.*ux + uy.*uy;
        cgrad = c(norm_grad2);
        cprim_grad = cprim(norm_grad2);
        uxx = zeros(N,N);
        uxx(:,1) = ux(:,1);
        uxx(:,2:N-1) = ux(:,2:N-1) - ux(:,1:N-2);
        uxx(:,N) = - ux(:,N-1);
        uyy = zeros(N,N);
        uyy(1,:) = uy(1,:);
        uyy(2:N-1,:) = uy(2:N-1,:) - uy(1:N-2,:);
        uyy(N,:) = - uy(N-1,:);
        uxy = zeros(N,N);
        uxy(:,1) = uy(:,1);
        uxy(:,2:N-1) = uy(:,2:N-1) - uy(:,1:N-2);
        uxy(:,N) = - uy(:,N-1);
        
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
                      
       % disp(norm(uee+unn-uxx-uyy));
        div_v = cgrad.*uee+(cgrad+2*norm_grad2.*cprim_grad).*unn;
%div_v = uxx+uyy;
%div_v = uee+unn;
        u = u + dt * div_v;
    end
    
    std = sqrt(2*K*dt);
    Gsigma = fspecial('gaussian',N-1,std);%/(4*pi*K*dt);
    sol2 = imfilter(u0,Gsigma,'symmetric');
    disp(norm(u-sol2));
    figure;imagesc(img/255);
    title(['LENA origine']);
    colorbar;
    colormap(gray);
    figure;imagesc(u0/255);
    title(['LENA bruitée']);
    colorbar;
    colormap(gray);
    figure;imagesc(u/255);
    title(['LENA solution EDP, k=',num2str(k),', dt=',num2str(dt)]);
    colorbar;
    colormap(gray);
    figure;imagesc(sol2/255);
    title(['LENA gaussienne']);
    colorbar;
    colormap(gray);
    figure;imagesc((u-sol2)/255);
    title(['LENA différence gaussienne / EDP']);
    colorbar;
    colormap(gray);
end