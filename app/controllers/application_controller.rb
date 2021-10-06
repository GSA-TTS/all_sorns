class ApplicationController < ActionController::Base
    before_action :reject_requests_with_invalid_characters

    INVALID_CHARACTERS = [
        "\u0000" # null bytes
    ].freeze

    private

    def reject_requests_with_invalid_characters
        if has_invalid_character?(request.params.values)
            raise ActionController::BadRequest
        end
    end

    # Currently checks strings and arrays in param values
    def has_invalid_character?(param_values)
        param_values.any? do |value|
            if value.respond_to?(:match)
                string_contains_invalid_character?(value)
            elsif value.is_a?(Array)
                value.any? do |array_value|
                    string_contains_invalid_character?(array_value) if array_value.respond_to?(:match)
                end
            end
        end
    end

    def string_contains_invalid_character?(string)
        invalid_characters_regex = Regexp.union(INVALID_CHARACTERS)

        string.match?(invalid_characters_regex)
    end
end
