# include the include ...
include("Include.jl")

# ======================================================================================== #
# PHASE 1: SERVER CONFIGURATION
# load the configuration file -
configuration_dictionary = TOML.parsefile(joinpath(_PATH_TO_CONFIG, "Configuration.toml"))
port_number = configuration_dictionary["server"]["port"]
host_ip_address = Sockets.getipaddr()

# show message to user -
start_message = "Server started. address: $(host_ip_address) port: $(port_number) at $(now())";
@info start_message

# setup shared resources
const PALIQUANT_SERVER_ROUTER = HTTP.Router()       # router handles HTTP request/response traffic
const PALIQUANT_SERVER_SESSION = Dict{String,Any}() # session is a temp storage area

# setup logging -
path_to_log_file = joinpath(_PATH_TO_LOG, configuration_dictionary["log"]["log_file_name"])
io = open(path_to_log_file, "w+")
simpleLogger = SimpleLogger(io)
with_logger(simpleLogger) do
    @info(start_message)
    flush(io)
end
# ======================================================================================== #

# ======================================================================================== #
# PHASE 2: DATABASE CONFIGURATION


with_logger(simpleLogger) do
    @info("Server startup ... completed phase 2")
    flush(io)
end
# ======================================================================================== #

# ======================================================================================== #
# PHASE 3: API ENDPOINTS AND SERVER START
try

    # endpoints -
    version = 1
    pq_base_url = "/paliquant/transaction/api/v$(version)"
    
    # test endpoint -
    HTTP.@register(PALIQUANT_SERVER_ROUTER, "POST", "$(pq_base_url)/test", test_server_logic)

    # start the server -
    HTTP.serve(PALIQUANT_SERVER_ROUTER, host_ip_address, port_number)

finally

    @info "Shutting down the pqserver ... move along. nothing to see here ..."
    flush(io)
    close(io)
end
# ======================================================================================== #