function x = cylindzero(nu, m, t)
    % x = CYLINDZERO(nu, m, t)  The mth positive real root of the function
    %   J(nu,x) cos(pi t) + Y(nu,x) sin(pi t) == 0
    % where J and Y are the Bessel functions of the first and second find.
    % 
    % m can be an array. nu and t must be scalars.
    %
    % The order nu must be postive.
    
    
    if length(nu) > 1
        error('cylindzero: the order must be a scalar')
    end
    if nu < 0
        error('cylindzero: the order must nonnegative')
    end

    if nargin < 3
        t = 0; 
    end

    % Which multiple of pi the first zero occurs at
    offset = -2 + (t <= 0);
    
    x = zeros(size(m));

    for i=1:numel(m)
        targetPhase = (m(i)+offset+t+1/2)*pi;
        if m(i) == 1 && t > 0 && t <= 0.25
            if t < 1e-4
                warning('cylindzero: tolerance first root maybe be less than expected')
            end
            f =  @(x) besselphase(nu,x) - targetPhase;
            x(i)  = ridders(f, 0, pi*t/3, 10*eps);
            continue
        end

        % First term in McMahon's expansion for root
        x(i) = targetPhase + (2*nu + 1)*pi/4;
        relerr = 1;
        n = 0;
        while abs(relerr) > eps && n < 20;
            [th,M2] = besselphase(nu,x(i));
            % From Newton's method
            relerr = (th-targetPhase)*pi*M2/2;
            x(i) = x(i)*(1 - relerr); 
            n = n + 1;
        end
        if n == 20
            error('cylindzero: failed to converge')
        end
    end
end
