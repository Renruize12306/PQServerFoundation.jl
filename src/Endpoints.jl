function test_api_endpoint(request::HTTP.Request)::HTTP.Response

    # initialize -
    response_json_dictionary = Dict{String,Any}()
    response_code = 200 # I'm an optimist ... default: all is good in the world

    try

        # First, lets get the body of the request, and then build the request_body_dictionary -
        # note: if this call fails, it will be captured in the catch - this is an insanely 
        # huge malfunction, so a 500 is going back to the user ... 
        request_body_dictionary = JSON.parse(String(request.body))

        # debug: did we we get anyting from the server?
        with_logger(simpleLogger) do
            @info("rcvd: $(request_body_dictionary)")
            flush(io)
        end

        # test logic: takes a string, reverses it and creates a nee field in the respone
        original_string = request_body_dictionary["to"];
        new_string = reverse(original_string)

        # package -
        response_json_dictionary["string_sent_to_server"] = original_string
        response_json_dictionary["string_sent_from_server"] = new_string

        # wrap and send -
        # encode -
        buffer = JSON.json(response_json_dictionary)
        response = HTTP.Response(response_code, buffer)

        # return -
        return response
    catch error
        
        # ooops ... if we get here, then something super bad happend. 
        # send 500 back to user, and log
        response_code = 500

        # can we get some error information please?
        msg = sprint(showerror, error, catch_backtrace())
        
        # log -
        with_logger(simpleLogger) do
            @error(msg)
            flush(io)
        end

        # check: give specific error messages per error type 
        response_json_dictionary["error"] = "Hmmm. that's not right"
        response_json_dictionary["status"] = 0
        if (isa(error, KeyError) == true)
            response_json_dictionary["error"] = "Key error: check your request for the correct keys"
        end

        # encode -
        buffer = JSON.json(response_json_dictionary)
        response = HTTP.Response(response_code, buffer)

        # return -
        return response
    end
end