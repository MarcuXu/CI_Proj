function run_ci(functions, varargin)
% run_ci Comprehensive testing framework for confidence interval functions
%   run_ci(functions) tests the specified confidence interval functions
%   under various distributions and parameters

% Test configuration parameters
config = struct(...
    'Sz', [10 100 1000 10000], ...       % Sample sizes to test
    'alphas', [0.25 0.1 0.05], ... % Confidence levels
    'repeats_n', 10000 ...          % Number of Monte Carlo iterations
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
end

function run_bernoulli_tests(func, config, bernoulli_cases)
fprintf('\nRunning Bernoulli Distribution Tests:\n');
fprintf('=====================================\n');

for i = 1:numel(bernoulli_cases)
    fprintf('\nTest case: %s (theta = %.2f, alphas=[%.2f %.2f %.2f])\n', ...
        bernoulli_cases(i).description, bernoulli_cases(i).theta, ...
        config.alphas(1), config.alphas(2), config.alphas(3));

    % Initialize confidence interval bounds
    lower_bound = zeros(config.repeats_n, 1); % Lower bounds
    upper_bound = zeros(config.repeats_n, 1); % Upper bounds
    fraction = [];

    for N = config.Sz
        for repeat = 1:config.repeats_n
            % Generate Bernoulli samples and calculate confidence interval
            X = generate_bernoulli_samples(N, bernoulli_cases(i).theta);
            [lower_bound(repeat), upper_bound(repeat)] = ci(X, func);
        end

        % Calculate fraction of valid intervals
        valid_intervals = (lower_bound <= bernoulli_cases(i).theta) & ...
            (bernoulli_cases(i).theta <= upper_bound);
        fraction = [fraction; sum(valid_intervals) / config.repeats_n];
    end

    % Report results
    report_results(config.alphas, config.Sz, fraction);
end
end

function run_uniform_tests(func, config, uniform_cases)
fprintf('\nRunning Uniform Distribution Tests:\n');
fprintf('==================================\n');

for i = 1:numel(uniform_cases)
    fprintf('\nTest case: %s ([%.2f, %.2f], alphas=[%.2f %.2f %.2f])\n', ...
        uniform_cases(i).description, ...
        uniform_cases(i).a, uniform_cases(i).b, ...
        config.alphas(1), config.alphas(2), config.alphas(3));

    % Initialize confidence interval bounds
    lower_bound = zeros(config.repeats_n, 1); % Lower bounds
    upper_bound = zeros(config.repeats_n, 1); % Upper bounds
    fraction = [];
    true_mean = (uniform_cases(i).a + uniform_cases(i).b) / 2;

    for N = config.Sz
        for repeat = 1:config.repeats_n
            % Generate Uniform samples and calculate confidence interval
            X = generate_uniform_samples(N, uniform_cases(i).a, uniform_cases(i).b);
            [lower_bound(repeat), upper_bound(repeat)] = ci(X, func);
        end

        % Calculate fraction of valid intervals
        valid_intervals = (lower_bound <= true_mean) & ...
            (true_mean <= upper_bound);
        fraction = [fraction; sum(valid_intervals) / config.repeats_n];
    end

    % Report results
    report_results(config.alphas, config.Sz, fraction);
end
end


function run_normal_tests(func, config, normal_cases)
fprintf('\nRunning Normal Distribution Tests:\n');
fprintf('=================================\n');

for i = 1:numel(normal_cases)
    fprintf('\nTest case: %s (μ=%.2f, σ=%.2f, alphas=[%.2f %.2f %.2f])\n', ...
        normal_cases(i).description, ...
        normal_cases(i).mu, normal_cases(i).sigma, ...
        config.alphas(1), config.alphas(2), config.alphas(3));

    % Initialize confidence interval bounds
    lower_bound = zeros(config.repeats_n, 1); % Lower bounds
    upper_bound = zeros(config.repeats_n, 1); % Upper bounds
    fraction = [];

    for N = config.Sz
        for repeat = 1:config.repeats_n
            % Generate Normal samples and calculate confidence interval
            X = generate_normal_samples(N, normal_cases(i).mu, normal_cases(i).sigma);
            X = max(0, min(1, X)); % Clip samples to [0, 1]
            [lower_bound(repeat), upper_bound(repeat)] = ci(X, func);
        end

        % Calculate fraction of valid intervals
        valid_intervals = (lower_bound <= normal_cases(i).mu) & ...
            (normal_cases(i).mu <= upper_bound);
        fraction = [fraction; sum(valid_intervals) / config.repeats_n];
    end

    % Report results
    report_results(config.alphas, config.Sz, fraction);
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

function report_results(alphas, Sz, fraction)
% Print results for each alpha
for alpha_idx = 1:length(alphas)
    % Print results for each sample size
    for i = 1:length(Sz)
        fprintf('Sample sizes: %5d\t missed fraction: %1.3f\n', ...
            Sz(i), 1 - fraction(i));
    end
    fprintf('\n');
end
fprintf('-----------------------------------------------------\n');
end

function print_header(func)
fprintf('\nFunction %d results:\n', func);
end
