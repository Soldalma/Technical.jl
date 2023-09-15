module Technical


using DataFrames, Dates

using Utils

#@calc_bollinger_bands
"""
    calc_bollinger_bands(
        prices::Vector{Float64},
        n::Int64,
        bands_size::Float64
    )::DataFrame

Calculate upper and lower bands around average prices. Distances are
multiples of recent standard deviation.

Return a dataframe with two columns named LowerBand and HigherBand and whose
number of rows is equal to the length of `prices`. The first `n-1` rows
will contain `NaN` values.

# Arguments
- `prices`: a vector of prices.
- `n`: the window size for the calculation of the mean and standard
        deviation.
- `bands_size`: multiplies the standard deviation to obtain the
    distances between the bands and prices.

# Examples
```jldoctest
julia> prices = 1.0 .+ randn(10)
julia> Technical.calc_bollinger_bands(prices, 5, 2.0)
10×2 DataFrame
    Row │ LowerBand    HigherBand
        │ Float64      Float64
    ─────┼─────────────────────────
    1 │ NaN           NaN
    2 │ NaN           NaN
    3 │ NaN           NaN
    4 │ NaN           NaN
    5 │  -0.0806365     1.33037
    6 │  -0.253034      1.63808
    7 │  -0.322289      1.99761
    8 │  -0.555508      2.05245
    9 │  -1.18636       2.27319
    10 │  -1.16464       3.02435
```
"""
function calc_bollinger_bands(
    prices::Vector{Float64},
    n::Int64,
    bands_size::Float64
)::DataFrame
    stddevs = Utils.rolling_std(prices, n)
    avg = Utils.rolling_mean(prices, n)

    bands = stddevs .* bands_size

    return DataFrame(
        :AveragePrice => avg,
        :LowerBand => avg .- bands,
        :HigherBand => avg .+ bands,
        :Price => prices
    )
end # calc_bollinger_bands

end
