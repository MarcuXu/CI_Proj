# Confidence Interval Testing Framework

A comprehensive MATLAB framework for validating and analyzing confidence interval implementations.

## Overview

This framework allows you to test confidence interval functions against multiple probability distributions with varying parameters and sample sizes. It helps determine:
- Validity of confidence interval implementations
- Actual confidence levels achieved
- Whether intervals are exact or asymptotic
- Performance across different distributions and edge cases

## Features

- **Multiple Distribution Testing**
  - Bernoulli (balanced, rare events, common events)
  - Uniform (full range, lower edge, upper edge)
  - Normal (standard, small variance, large variance)

- **Comprehensive Testing Parameters**
  - Sample sizes: 10, 100, 1000, 10000
  - Confidence levels: 75%, 90%, 95%
  - 10,000 iterations per test

- **Edge Case Coverage**
  - Extreme probabilities in Bernoulli (θ = 0.01, 0.99)
  - Boundary regions in Uniform ([0, 0.05], [0.95, 1])
  - Various variance scales in Normal (σ = 0.1, 0.9, 1)

## Usage

### Basic Usage

Test a single confidence interval function:
```matlab
run_ci(1)  % Test function #1
```

Test multiple functions:
```matlab
run_ci([1 3 5])  % Test functions 1, 3, and 5
```

### Advanced Usage

You can set up the below custom configuration:
```matlab
config = struct(...
    'Sz', [50 500 5000], ...         % Custom sample sizes
    'alphas', [0.1 0.05 0.01], ...   % Custom confidence levels
    'repeats_n', 5000 ...             % Custom iterations
);
run_ci([1 2], config)
```

## Test Cases

### Bernoulli Distribution
- Balanced case (θ = 0.5)
- Rare events (θ = 0.01)
- Common events (θ = 0.99)

### Uniform Distribution
- Full range [0, 1]
- Lower edge [0, 0.05]
- Upper edge [0.95, 1]

### Normal Distribution
- Standard Normal (μ = 0, σ = 1)
- Small variance (μ = 0.5, σ = 0.1)
- Large variance (μ = 0.5, σ = 0.9)

## Output Interpretation

The framework outputs test results in the following format:
```
Function 5 results:

Running Bernoulli Distribution Tests:
=====================================

Test case: balanced (theta = 0.50, alphas=[0.25 0.10 0.05])
Sample sizes:    10	 missed fraction: 0.079
Sample sizes:   100	 missed fraction: 0.090
Sample sizes:  1000	 missed fraction: 0.097
Sample sizes: 10000	 missed fraction: 0.104
```

### Interpreting Results

1. **Validity**
   - Function is valid if fraction missed < α for all test cases
   - Consistent performance across distributions indicates robustness

2. **Confidence Level**
   - Actual confidence level = (1 - fraction_missed) × 100%
   - Use large N (10000) results for most accurate estimation

3. **Exact vs Asymptotic**
   - Exact: Similar fraction missed across all N
   - Asymptotic: Higher fraction missed for small N, converging as N increases

### Brief Description of the Function Validity Process

1. **Generate Confidence Intervals**: Perform $10,000$ simulations for each of the 10 functions, testing across sample sizes ($N = 10, 100, 1000, 10,000$) and distributions (Bernoulli, Uniform, Normal).
2. **Initial Validity Check**: Calculate the fraction of intervals that fail to include the true mean (missed fraction). If the missed fraction is less than or equal to $\alpha$, the function is **valid**; otherwise, it is **invalid**. We set up $\alpha = 0.25$ here empirically.
3. **Determine Confidence Level**: For valid functions, compare the missed fraction to smaller $\alpha$ values (like $0.1, 0.05, 0.01$) to determine the highest valid confidence level.
4. **Assess Validity Across Sizes**:
    Evaluate missed fractions across sample sizes to classify validity as:
        * **Exact**: Consistent validity for all sizes.
        * **Asymptotic**: Validity holds BETTER for large sizes.
5. **Report Results**: Summarize the validity, confidence level, and classification (Exact/Asymptotic) for each function.

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE.md](ci-testing-license.md) file for details.