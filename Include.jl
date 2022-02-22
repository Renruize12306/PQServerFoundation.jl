# Setup server paths -
_PATH_TO_ROOT = pwd()
_PATH_TO_SRC = joinpath(_PATH_TO_ROOT,"src")
_PATH_TO_LOG = joinpath(_PATH_TO_ROOT,"log")
_PATH_TO_DATABASE = joinpath(_PATH_TO_ROOT,"database")
_PATH_TO_CONFIG = joinpath(_PATH_TO_ROOT,"config")


include("/Users/ruiren/Desktop/Software/Lab/Ruize/VL_LimitOrderBook/src/VL_LimitOrderBook.jl")
# load external packages required by the server -
using HTTP
using JSON
using TOML
using DataFrames
using CSV
using Sockets
using Logging
using Dates
using SQLite
using Main.VL_LimitOrderBook

# load my codes -
include(joinpath(_PATH_TO_SRC,"Endpoints.jl"))
