function test_ci_uniform(func, Ns, alphas, nrepeats, a, b)

A = zeros(nrepeats, 1);
B = zeros(nrepeats, 1);

fraction = [];
fprintf('Using uniform distribution (%1.2f, %1.2f) as input\n', a, b);
fprintf('----------------------------------------------\n\n');

for N = Ns
    for repeat = 1:nrepeats
        X = sample_uniform(N, a, b);
        [A(repeat), B(repeat)] = ci(X, func);
    end
    true_mean = (a + b) / 2; 
    fraction = [fraction; sum((A <= true_mean) & (true_mean <= B)) / nrepeats];
end
for alpha=alphas
    for i=1:length(Ns)
        fprintf('alpha: %1.2f\t N: %5d\t fraction missed: %1.3f\n', ...
            alpha, Ns(i), 1 - fraction(i));  
    end
    fprintf('\n');
end
fprintf('-----------------------------------------------------\n\n');
end