function test_ci_beta(func, Ns, alphas, nrepeats, a, b)

A = zeros(nrepeats, 1);
B = zeros(nrepeats, 1);

fraction = [];
fprintf('Using beta distribution with a = %d, b = %d as input\n', a, b);
fprintf('----------------------------------------------\n\n');

for N = Ns
    for repeat = 1:nrepeats
        X = sample_beta(N, a, b);
        [A(repeat), B(repeat)] = ci(X, func);
    end
    true_mean = a / (a + b); 
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