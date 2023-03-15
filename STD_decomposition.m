function [S,T,D,R] = STD_decomposition(data,period,is_reminder)
% STD_decomposition - seasonal-trend-dispersion decomposition of time series
%
% data - time series, 1 x N or N x 1
% period - length of the seasonal cycle
% is_reminder - 0 for STD (without reminder), 1 for STDR (with reminder)
% S - seasonal component, 1 x N
% T - trend component, 1 x N
% D - dispersion component, 1 x N
% R - reminder component, [] for STD, 1 x N for STDR

if iscolumn(data)
    y = data';
else
    y = data;
end
n = period;
N = length(y);
K = N/n;

if rem(N,n)
    disp(['Length of the series (', num2str(N),') should be a multiple of the seasonal period (', num2str(n),')']);
end

yy = reshape(y,n,K);

%trend
ym = mean(yy); 
q = repmat(ym,n,1); 
T = q(:)'; 

%dispersion
yd = (sum((yy-q).^2)).^0.5;
q = repmat(yd,n,1); 
D = q(:)'; 

%seasonal for STD
S = (y - T)./D; 
S = S(:)'; 

%reminder for STD
R = []; 

%seasonal and reminder for STDR
if is_reminder 
    q = reshape(S,n,K);
    sp = mean(q,2)';
    S = repmat(sp,1,K);
    R = y - (S.*D + T);
end

