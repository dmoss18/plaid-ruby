module Plaid
  # Public: Base class for Plaid SDK errors
  class PlaidError < StandardError; end

  # Public: returned on Plaid server or network issues
  class PlaidServerError < PlaidError; end

  # Public: Base class for any error returned by the API
  class PlaidAPIError < PlaidError
    attr_reader :error_type, :error_code, :error_message, :display_message, :request_id

    # Internal: Initialize an error with proper attributes
    #
    # error_type      - A broad categorization of the error
    # error_code      - The particular error code
    # error_message   - A developer-friendly representation of the error message
    # display_message - A user-friendly representation of the error message
    # request_id      - The ID of the request you made, can be used to escalate problems
    def initialize(error_type, error_code, error_message, display_message, request_id)
      @error_type      = error_type
      @error_code      = error_code
      @error_message   = error_message
      @display_message = display_message
      @request_id      = request_id

      super "\n"\
            "Error Type      : #{@error_type}\n"\
            "Error Code      : #{@error_code}\n"\
            "Error Message   : #{@error_message}\n"\
            "Display Message : #{@display_message}\n"\
            "Request ID      : #{@request_id}\n"
    end
  end

  # Public: returned when the request is malformed and cannot be processed.
  class InvalidRequestError    < PlaidAPIError; end

  # Public: returned when all fields are provided and are in the correct format,
  #         but the values provided are incorrect in some way.
  class InvalidInputError      < PlaidAPIError; end

  # Public: returned when the request is valid but has exceeded established rate limits.
  class RateLimitExceededError < PlaidAPIError; end

  # Public: returned during planned maintenance windows and
  #         in response to API internal server errors.
  class APIError               < PlaidAPIError; end

  # Public: indicates that information provided for the item (such as credentials or MFA)
  #         may be invalid or that the item is not supported on Plaid's platform.
  class ItemError              < PlaidAPIError; end

  # Internal: A module that provides utilities for errors.
  module Error
    # Internal: Map error_type to PlaidAPIError
    #
    # Maps an error_type from an error HTTP response to an actual PlaidAPIError class instance
    #
    # error_type - The type of the error as indicated by the error response body
    #
    # Returns an error class mapped from error_type
    def self.error_from_type(error_type)
      case error_type
      when 'INVALID_REQUEST'
        Plaid::InvalidRequestError
      when 'INVALID_INPUT'
        Plaid::InvalidInputError
      when 'RATE_LIMIT_EXCEEDED_ERROR'
        Plaid::RateLimitExceededError
      when 'API_ERROR'
        Plaid::APIError
      when 'ITEM_ERROR'
        Plaid::ItemError
      else
        Plaid::PlaidAPIError
      end
    end
  end
end
