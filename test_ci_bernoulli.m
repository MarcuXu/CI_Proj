function test_ci_bernoulli(func, Ns, alphas, nrepeats, theta)

A = zeros(nrepeats, 1);
B = zeros(nrepeats, 1);

fraction = [];
fprintf('Using bernoulli distribution with theta = %1.2f as input\n', theta);
fprintf('-----------------------------------------------------\n\n');

for N = Ns
    for repeat = 1:nrepeats
        X = sample_bernoulli(N, theta);
        [A(repeat), B(repeat)] = ci(X, func);
    end
    fraction = [fraction; sum((A <= theta) & (theta <= B)) / nrepeats];       
end
for alpha=alphas
    for i=1:length(Ns)
        fprintf('alpha: %1.2f\t N: %5d\t fraction missed: %1.3f\n', ...
            alpha, Ns(i), 1 - fraction(i));  
    end
    fprintf('\n');
end
fprintf('-----------------------------------------------------\n\n');
