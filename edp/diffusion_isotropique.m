function diffusion_isotropique()
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
    
        grad_x = zeros(N,N);
        grad_x(:,1:N-1) = u(:,2:N) - u(:,1:N-1);
    
        grad_y = zeros(N,N);
        grad_y(1:N-1,:) = u(2:N,:) - u(1:N-1,:);

        div_v = zeros(N,N);

        div_v(:,1) = grad_x(:,1);
        div_v(:,2:N-1) = grad_x(:,2:N-1) - grad_x(:,1:N-2);
        div_v(:,N) = - grad_x(:,N-1);


        div_v(1,:) = div_v(1,:) + grad_y(1,:);
        div_v(2:N-1,:) = div_v(2:N-1,:) + grad_y(2:N-1,:) - grad_y(1:N-2,:);
        div_v(N,:) = div_v(N,:) - grad_y(N-1,:);

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