function test_ci_normal(func, Ns, alphas, nrepeats, mu, sigma)
% Test confidence intervals using normal distribution
% Parameters:
%   func     - confidence interval function to test
%   Ns       - array of sample sizes to test
%   alphas   - array of significance levels
%   nrepeats - number of Monte Carlo iterations
%   mu       - mean of normal distribution
%   sigma    - standard deviation of normal distribution

A = zeros(nrepeats, 1);
B = zeros(nrepeats, 1);

fraction = [];
fprintf('Using normal distribution N(%1.2f, %1.2f) as input\n', mu, sigma);
fprintf('-----------------------------------------------------\n\n');

for N = Ns
    for repeat = 1:nrepeats
        X = sample_normal(N, sigma, mu);
        [A(repeat), B(repeat)] = ci(X, func);
    end
    % Calculate fraction of intervals containing true mean
    fraction = [fraction; sum((A <= mu) & (mu <= B)) / nrepeats];
end

% Report results for each alpha and sample size
for alpha = alphas
    for i = 1:length(Ns)
        fprintf('alpha: %1.2f\t N: %5d\t fraction missed: %1.3f\n', ...
            alpha, Ns(i), 1 - fraction(i));
    end
    fprintf('\n');
end
fprintf('-----------------------------------------------------\n\n');
end