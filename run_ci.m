function run_ci(functions, varargin)
    % TEST_CI Comprehensive testing framework for confidence interval functions
    %   test_ci(functions) tests the specified confidence interval functions
    %   under various distributions and parameters
    
    % Test configuration parameters
    config = struct(...
        'Ns', [10 100 1000 10000], ...       % Sample sizes to test
        'alphas', [0.25 0.1 0.05], ... % Confidence levels
        'nrepeats', 10000 ...          % Number of Monte Carlo iterations
    );
    
    % Test cases definition
    test_cases = struct();
    
    % Bernoulli test cases
    test_cases.bernoulli = struct(...
        'theta', {0.5, 0.01, 0.99}, ...
        'description', {'balanced', 'rare events', 'common events'} ...
    );
    
    % Uniform test cases
    test_cases.uniform = struct(...
        'a', {0, 0, 0.95}, ...
        'b', {1, 0.05, 1}, ...
        'description', {'full range', 'lower edge', 'upper edge'} ...
    );
    
    % Normal test cases
    test_cases.normal = struct(...
        'mu', {0, 0.5, 0.5}, ...
        'sigma', {1, 0.1, 0.9}, ...
        'description', {'standard normal', 'small variance', 'large variance'} ...
    );
    
    % Run tests for each function
    for func = functions
        run_function_tests(func, config, test_cases);
    end
end

function run_function_tests(func, config, test_cases)
    % Print function header
    print_header(func);
    
    % Run Bernoulli tests
    run_bernoulli_tests(func, config, test_cases.bernoulli);
    
    % Run Uniform tests
    run_uniform_tests(func, config, test_cases.uniform);
    
    % Run Normal tests
    run_normal_tests(func, config, test_cases.normal);
    
    % Print function footer
    print_footer(func);
end

function run_bernoulli_tests(func, config, bernoulli_cases)
    fprintf('\nRunning Bernoulli Distribution Tests:\n');
    fprintf('=====================================\n');
    
    for i = 1:numel(bernoulli_cases)
        fprintf('\nTest case: %s (theta = %.2f)\n', ...
            bernoulli_cases(i).description, bernoulli_cases(i).theta);
        
        A = zeros(config.nrepeats, 1);
        B = zeros(config.nrepeats, 1);
        fraction = [];
        
        for N = config.Ns
            for repeat = 1:config.nrepeats
                % Generate Bernoulli samples
                X = generate_bernoulli_samples(N, bernoulli_cases(i).theta);
                [A(repeat), B(repeat)] = ci(X, func);
            end
            fraction = [fraction; sum((A <= bernoulli_cases(i).theta) & ...
                (bernoulli_cases(i).theta <= B)) / config.nrepeats];
        end
        
        report_results(config.alphas, config.Ns, fraction);
    end
end

function run_uniform_tests(func, config, uniform_cases)
    fprintf('\nRunning Uniform Distribution Tests:\n');
    fprintf('==================================\n');
    
    for i = 1:numel(uniform_cases)
        fprintf('\nTest case: %s ([%.2f, %.2f])\n', ...
            uniform_cases(i).description, ...
            uniform_cases(i).a, uniform_cases(i).b);
        
        A = zeros(config.nrepeats, 1);
        B = zeros(config.nrepeats, 1);
        fraction = [];
        true_mean = (uniform_cases(i).a + uniform_cases(i).b) / 2;
        
        for N = config.Ns
            for repeat = 1:config.nrepeats
                % Generate Uniform samples
                X = generate_uniform_samples(N, uniform_cases(i).a, uniform_cases(i).b);
                [A(repeat), B(repeat)] = ci(X, func);
            end
            fraction = [fraction; sum((A <= true_mean) & ...
                (true_mean <= B)) / config.nrepeats];
        end
        
        report_results(config.alphas, config.Ns, fraction);
    end
end

function run_normal_tests(func, config, normal_cases)
    fprintf('\nRunning Normal Distribution Tests:\n');
    fprintf('=================================\n');
    
    for i = 1:numel(normal_cases)
        fprintf('\nTest case: %s (μ=%.2f, σ=%.2f)\n', ...
            normal_cases(i).description, ...
            normal_cases(i).mu, normal_cases(i).sigma);
        
        A = zeros(config.nrepeats, 1);
        B = zeros(config.nrepeats, 1);
        fraction = [];
        
        for N = config.Ns
            for repeat = 1:config.nrepeats
                % Generate Normal samples
                X = generate_normal_samples(N, normal_cases(i).mu, normal_cases(i).sigma);
                % Ensure samples are within [0,1]
                X = max(0, min(1, X));
                [A(repeat), B(repeat)] = ci(X, func);
            end
            fraction = [fraction; sum((A <= normal_cases(i).mu) & ...
                (normal_cases(i).mu <= B)) / config.nrepeats];
        end
        
        report_results(config.alphas, config.Ns, fraction);
    end
end

function X = generate_bernoulli_samples(N, theta)
    % Generate N Bernoulli samples with parameter theta
    X = double(rand(N, 1) < theta);
end

function X = generate_uniform_samples(N, a, b)
    % Generate N Uniform samples in [a,b]
    X = a + (b-a)*rand(N, 1);
end

function X = generate_normal_samples(N, mu, sigma)
    % Generate N Normal samples with mean mu and std sigma
    X = randn(N, 1)*sigma + mu;
end

function report_results(alphas, Ns, fraction)
    for alpha = alphas
        for i = 1:length(Ns)
            fprintf('alpha: %1.2f\t N: %5d\t fraction missed: %1.3f\n', ...
                alpha, Ns(i), 1 - fraction(i));
        end
        fprintf('\n');
    end
    fprintf('-----------------------------------------------------\n');
end

function print_header(func)
    fprintf('\nFunction %d:\n', func);
    fprintf('=====================================================\n');
end

function print_footer(func)
    fprintf('\n----------------END OF FUNCTION: %d------------------\n\n', func);
end