function y = vumeter(x, fs )

% y = vumeter( x, fs )
% x are the samples of the signal
% fs is the sampling rate

if round(fs) ~= fs
   disp('non-integer sampling rates not supported')
   y = [];
else

   D = 8;  % This is how much the signal will be upsampled by to preserve
           % the high frequency content created by the abs(x)
   
   wn = 13.5119125366;
   zeta = .81271698642867751129343563262192;
   
   Td = 1/fs/D;
   
   B = Td^2 * wn^2 * [ 1 2 1 ];
   A = [ ( 4 + 4*zeta*wn*Td + wn^2*Td^2) (-8 + 2*wn^2*Td^2) (4 - 4*zeta*wn*Td + wn^2*Td^2) ];
   

   % Note:  there is a danger in using a too small sampling rate.  If a small
   %        sampling rate is used it causes serious problems with avg_value.

   %avg_value = mean(abs(sin( 2*pi*1000/fs * [0:fs-1] )));
   
   %scaling = 1 / ( avg_value * sqrt(600*0.001*2) )^1.2;
   %scaling = 1 / ( avg_value * sqrt(600*0.001*2) );   
   scaling = pi / 2 / sqrt(600*0.001*2) ;

   %y = ( scaling * filter(B,A,abs(x)).^1.2 ).^(1/1.2);
   
   x_u = resample( x, D, 1,50 );  %interp( x, D );
   y_u = scaling * filter(B,A,abs(x_u));
   y = y_u(1:D:end); % decimate( y_u, D );

end